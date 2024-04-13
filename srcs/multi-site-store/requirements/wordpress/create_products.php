<?php

$lang = $argv[1];

$csvFile = "/tmp/products/updated_" . $lang . ".csv";

$columnsToPrint = ["name", "description", "small_text", "price", "picture", "meta_description", "on_sale", "sale_price", "category_id"];

$site = $lang . ".bio113-dev.com";

if (($handle = fopen($csvFile, "r")) !== FALSE) {
    $header = fgetcsv($handle);
    $columnsIndex = array_flip($header);

    while (($row = fgetcsv($handle)) !== FALSE) {
        $values = [];
        foreach ($columnsToPrint as $column) {
            $values[$column] = $row[$columnsIndex[$column]];
        }

        #remote image url

        $yesterdayDate = date('Y-m-d', strtotime('-1 day'));

        $images = json_encode([["src" => "https://" . "bio113.com/th/340x300_6/" . trim($values["picture"], '/')]]);

        $ret = array();

        if ($values["on_sale"] == 0 || $values["sale_price"] == 0) {
            echo "not on sale name " . $values["name"] . "\n";
            $command_with_image = "wp --url={$site} wc product create " .
                       "--path=/var/www/wordpress " .
                       "--name='" . $values["name"] . "' " .
                       "--type=simple " .
                       "--description='" . $values["description"] . "' " .
                       "--short_description='" . $values["small_text"] . "' " .
                       "--categories='[{\"id\": " . $values["category_id"] . "}]' " .
                       "--regular_price=" . $values["price"] . " " .
                       "--sale_price=" . $values["sale_price"] . " " .
                       "--images='" . $images . "' " .
                       "--date_on_sale_to='" . $yesterdayDate . "' " .
                       "--user=admin 2>&1";

            $command_without_image = "wp --url={$site} wc product create " .
                       "--path=/var/www/wordpress " .
                       "--name='" . $values["name"] . "' " .
                       "--type=simple " .
                       "--description='" . $values["description"] . "' " .
                       "--short_description='" . $values["small_text"] . "' " .
                       "--categories='[{\"id\": " . $values["category_id"] . "}]' " .
                       "--regular_price=" . $values["price"] . " " .
                       "--sale_price=" . $values["sale_price"] . " " .
                       "--date_on_sale_to='" . $yesterdayDate . "' " .
                       "--user=admin 2>&1";

        } else {
            echo "on sale name " . $values["name"] . "\n";
            $command_with_image = "wp --url={$site} wc product create " .
                       "--path=/var/www/wordpress " .
                       "--name='" . $values["name"] . "' " .
                       "--type=simple " .
                       "--description='" . $values["description"] . "' " .
                       "--short_description='" . $values["small_text"] . "' " .
                       "--categories='[{\"id\": " . $values["category_id"] . "}]' " .
                       "--regular_price=" . $values["price"] . " " .
                       "--sale_price=" . $values["sale_price"] . " " .
                       "--date_on_sale_from='" . $yesterdayDate . "' " .
                       "--images='" . $images . "' " .
                       "--user=admin 2>&1";

            $command_without_image = "wp --url={$site} wc product create " .
                       "--path=/var/www/wordpress " .
                       "--name='" . $values["name"] . "' " .
                       "--type=simple " .
                       "--description='" . $values["description"] . "' " .
                       "--short_description='" . $values["small_text"] . "' " .
                       "--categories='[{\"id\": " . $values["category_id"] . "}]' " .
                       "--regular_price=" . $values["price"] . " " .
                       "--sale_price=" . $values["sale_price"] . " " .
                       "--date_on_sale_from='" . $yesterdayDate . "' " .
                       "--user=admin 2>&1";
        }

        exec($command_with_image, $ret, $out);

        if (str_contains($ret[0], 'error 7')) {
          echo "ERROR 7\nStaring to loop\n";
          $ret = array();
          exec($command_with_image, $ret, $out);
          while (!str_contains($ret[0], 'error 7')) {
            echo "ERROR 7\nStaring to loop\n";
            $ret = array();
            exec($command_with_image, $ret, $out);
          }
        } elseif (str_contains($ret[0], 'Not Found')) {
          echo "Image not Found creating product with out image\n";
          exec($command_without_image, $ret, $out);
          echo "Result from the return function: $ret";
        } else {
          echo $ret[0] . "\n";
        }
    }
    fclose($handle);
}
?>
