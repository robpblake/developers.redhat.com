<?php

use Phinx\Migration\AbstractMigration;

class RemoveDuplicateUrlAliasesMigration extends AbstractMigration
{
    /**
     * Deletes rows from the lightning_url_aliases table with duplicate values
     * for the source and alias columns, such that only one row of each set of
     * duplicates remains. Arbitrarily, this will be the row with the lowest
     * pid.
     */
	public function up()
    {
		$this->execute("DELETE FROM lightning_url_alias WHERE pid IN (
            SELECT i.pid
            FROM (SELECT * FROM lightning_url_alias) AS i
            INNER JOIN (
                SELECT k.source, min(k.pid) as minId
                FROM (SELECT * FROM lightning_url_alias) AS k
                GROUP BY k.source, k.alias
                HAVING COUNT(*) > 1
            ) AS j ON i.source=j.source WHERE i.pid > j.minId
		);");
    }
}
