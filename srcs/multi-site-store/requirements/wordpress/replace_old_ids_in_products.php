<?php

$lang=$argv[1];
// Step 1: Create the mapping from the first CSV file (old_id to id)
$mappingCsvFile='categories/categories_updated_' . $lang . '.csv';

$mapping = [];

if (($handle = fopen($mappingCsvFile, 'r')) !== FALSE) {
    $header = fgetcsv($handle); // Assuming the file has a header
    while (($row = fgetcsv($handle)) !== FALSE) {
        $id = $row[0]; // Assuming 'id' is the first column
        $oldId = $row[5]; // Assuming 'old_id' is the sixth column
        $mapping[$oldId] = $id;
    }
    fclose($handle);
}
// Step 2: Read the second CSV file and prepare to replace category_id
$dataCsvFile='products/' . $lang . '.csv';
$updatedRows = [];
if (($handle = fopen($dataCsvFile, 'r')) !== FALSE) {
    $header = fgetcsv($handle); // Capture the header
    while (($row = fgetcsv($handle)) !== FALSE) {
        $category_id = $row[9]; // Assuming 'category_id' is the fourth column

        if (isset($mapping[$category_id])) {
            $row[9] = $mapping[$category_id]; // Replace category_id with the new id
        }
        $updatedRows[] = $row;
    }
    fclose($handle);
}

// Step 3: Write the updated data to a new CSV file
$newCsvFile = 'products/updated_' . $lang . '.csv';

if ($handle = fopen($newCsvFile, 'w')) {
    fputcsv($handle, $header); // Write the header first
    foreach ($updatedRows as $row) {
        fputcsv($handle, $row); // Write each updated row
    }
    fclose($handle);
}

?>
