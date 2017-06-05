<?php

namespace PhpOffice\PhpSpreadsheetTests\Style;

use PhpOffice\PhpSpreadsheet\Shared\StringHelper;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;

class NumberFormatDateTest extends \PHPUnit_Framework_TestCase
{
    public function setUp()
    {
        StringHelper::setDecimalSeparator('.');
        StringHelper::setThousandsSeparator(',');
    }

    /**
     * @dataProvider providerNumberFormat
     */
    public function testFormatValueWithMask()
    {
        $args = func_get_args();
        $expectedResult = array_pop($args);
        $result = call_user_func_array([NumberFormat::class, 'toFormattedString'], $args);
        $this->assertEquals($expectedResult, $result);
    }

    public function providerNumberFormat()
    {
        return require 'data/Style/NumberFormatDates.php';
    }
}
