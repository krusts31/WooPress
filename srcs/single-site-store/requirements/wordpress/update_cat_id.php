<?php

$lang=$argv[1];
// Load the CSV file
$csvFile='categories/categories_new_' . $lang . '.csv';
$rows = array_map('str_getcsv', file($csvFile));
$header = array_shift($rows);
$data = array();


$oldIdToIdMap = array();

foreach ($rows as $row) {
    $oldIdToIdMap[$row[5]] = $row[0];
}

// Update Parent values
foreach ($rows as $key => $row) {

    if (isset($oldIdToIdMap[$row[3]])) {
	echo $rows[$key][3] . " replaced with-> " . $oldIdToIdMap[$row[3]] . "\n";
        $rows[$key][3] = $oldIdToIdMap[$row[3]];
    }
}

$newCsvFile = 'categories/categories_updated_' . $lang . '.csv';

$handle = fopen($newCsvFile, 'w');
fputcsv($handle, $header);
foreach ($rows as $row) {
    fputcsv($handle, $row);
}
fclose($handle);
?>
