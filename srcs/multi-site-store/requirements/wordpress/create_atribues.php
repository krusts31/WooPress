<?php

$lang = $argv[1];

$csvFile = "/tmp/categories/categories_" . $lang . ".csv";

$site = $lang . ".bio113-dev.com";

$columns = ["id", "name", "parent", "description", "image"];

if (($handle = fopen($csvFile, "r")) !== FALSE) {

    $header = fgetcsv($handle);

    $columnsIndex = array_flip($header);

    while (($row = fgetcsv($handle)) !== FALSE) {
        $values = [];
        foreach ($columns as $column) {
            $values[$column] = $row[$columnsIndex[$column]];
        }

        $ret = array();

        $command_with_image = "wp --url={$site} wc product_attribute create" .
                   " --path=/var/www/wordpress" .
                   " --name=" . '"' . $values["name"] . '"' .
                   " --user=admin";
                   #"--description=" . $values["description"] .
                   #"--parent=" .  $values["parents"] .
                   #"--images=" . $images .

        echo $command_with_image . "\n";


        exec($command_with_image, $ret, $out);
        echo $ret[0] . "\n";
    }
    fclose($handle);
}
