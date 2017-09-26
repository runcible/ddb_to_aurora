CREATE SCHEMA `zefdb`

CREATE TABLE `zefdb`.`node_measures` (
  `ts` BIGINT(6) NOT NULL,
  `nodeid` VARCHAR(10) NULL,
  `timestamp` BIGINT(6) NULL,
  `logging` BIGINT(6) NULL,
  `measure` INT NULL,
  `measure_type` VARCHAR(10) NULL);
