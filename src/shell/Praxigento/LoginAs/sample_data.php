<?php
/**
 * Copyright (c) 2015, Praxigento
 * All rights reserved.
 */

/**
 * User: Alex Gusev <alex@flancer64.com>
 */
/*
 *  __DIR__ returns absolute path if Magento module is mounted using symbolic link
 * we need to include __DIR__ . '/../../abstract.php'
 */
$dir = dirname(dirname(dirname($_SERVER['SCRIPT_NAME'])));
require_once $dir . '/abstract.php';

class Praxigento_Shell extends Mage_Shell_Abstract
{
    const OPT_CREATE = 'create';
    /** @var Logger */
    private $_log;
    private $_fileNameCustomers;


    public function __construct()
    {
        parent::__construct();
        $this->_log = Praxigento_LoginAs_Model_Logger::getLogger(__CLASS__);
        $this->_fileNameCustomers = dirname($_SERVER['SCRIPT_NAME']) . '/data_customers.csv';
    }

    /**
     * Run script
     *
     */
    public function run()
    {
        $create = $this->getArg(self::OPT_CREATE);
        if ($create) {
            $this->_log->debug("Sample data generation is started.");
            if ($create) {
                $this->_createCustomers();
            }
            $this->_log->debug("Sample data generation is completed.");
            echo 'Done.';
        } else {
            echo $this->usageHelp();
        }

    }

    private function _createCustomers()
    {
        $records = $this->_readDataCustomers($this->_fileNameCustomers);
        $count = sizeof($records);
        if ($count) {
            $this->_log->debug("Total $count lines are read from file {$this->_fileNameCustomers}");
            foreach ($records as $one) {
                $this->_createCustomerEntry($one);
            }
        }
    }

    /**
     * Read file with data, parse and return array of Records.
     * @param $path
     * @return RecordCustomer[]
     */
    private function _readDataCustomers($path)
    {
        $result = array();
        /* registry to uniquelize emails */
        $emailReg = array();
        if (file_exists($path)) {
            $content = file($path);
            foreach ($content as $one) {
                $data = explode(',', trim($one));
                $obj = new RecordCustomer();
                $obj->nameFirst = $data[0];
                $obj->nameLast = $data[1];
                $obj->groupId = $data[3];
                /**/
                $email = strtolower(trim($data[2]));
                if (isset($emailReg[$email])) {
                    $emailReg[$email]++;
                    $parts = explode('@', $email);
                    $email = $parts[0] . $emailReg[$email] . '@' . $parts[1];
                } else {
                    $emailReg[$email] = 0;
                }
                $obj->email = $email;
                $result[] = $obj;
            }
        } else {
            $this->_log->error("Cannot open file '$path'.");
        }
        return $result;
    }

    private function _createCustomerEntry(RecordCustomer $rec)
    {
        $nameFirst = $rec->nameFirst;
        $nameLast = $rec->nameLast;
        $email = $rec->email;
        /* save customer and update customer group */
        /** @var  $customer Mage_Customer_Model_Customer */
        $customer = Mage::getModel('customer/customer');
        $customer->setFirstname($nameFirst);
        $customer->setLastname($nameLast);
        $customer->setEmail($email);
        $customer->setWebsiteId(1);
        try {
            $customer->save();
            $this->_log->trace("New customer '$nameFirst $nameLast <$email>' is saved.");
        } catch (Exception $e) {
            $this->_log->error("Cannot save customer '$nameFirst $nameLast <$email>'.", $e);
        }
    }


    /**
     * Retrieve Usage Help Message
     *
     */
    public function usageHelp()
    {
        return <<<USAGE
Usage:  php -f sample_data.php [options]

  --create      Create sample data.

USAGE;
    }
}

/**
 * Class RecordCustomer Bean to group data from data file with customer info.
 */
class RecordCustomer
{
    public $nameFirst;
    public $nameLast;
    public $email;
    public $groupId;
}


/* prevent Notice: A session had already been started */
session_start();
$shell = new Praxigento_Shell();
$shell->run();
