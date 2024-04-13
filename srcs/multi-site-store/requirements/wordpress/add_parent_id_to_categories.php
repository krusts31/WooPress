<?php

$lang = $argv[1];

$newCsvFilePath = "/tmp/categories/categories_new_" . $lang . ".csv";

$newCsvFile = fopen($newCsvFilePath, 'w');

$headers = ["ID", "Name", "Description", "Parent", "Image", "OldID"];

$site = $lang . ".bio113-dev.com";

if (($handle = fopen($csvFile, "r")) !== FALSE) {

    $header = fgetcsv($handle);

    $columnsIndex = array_flip($header);

    while (($row = fgetcsv($handle)) !== FALSE) {
        $values = [];
        foreach ($headers as $column) {
            $values[$column] = $row[$columnsIndex[$column]];
        }

        $ret = array();


        if $values["Parent"] != 0 {
            $command_with_image = "wp --url={$site} term update product_cat create" .
                       " --path=/var/www/wordpress" .
                       " --name=\"" . $values["Name"] . "\"" .
                       " --description=\"" . $values["Description"] . "\"" .
                       #" --parent=" .  $values["Parent"] .
                       " --user=admin" .
                       " --porcelain";
                       #"--images=" . $images .
        }

        echo $command_with_image . "\n";

        exec($command_with_image, $ret, $out);
        echo $ret[0] . "\n";
        $newCsvRow = [$ret[0], trim($values["Name"], '"'), $values["Description"], $values["Parent"], $values["Image"], $values["ID"]];

        fputcsv($newCsvFile, $newCsvRow);
    }
    fclose($handle);
    fclose($newCsvFile);
}
