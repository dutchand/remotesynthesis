DROP TABLE IF EXISTS `xbox`.`accessory`;
CREATE TABLE  `xbox`.`accessory` (
  `accessoryID` char(35) NOT NULL,
  `accessoryName` varchar(45) NOT NULL,
  PRIMARY KEY  (`accessoryID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `xbox`.`console`;
CREATE TABLE  `xbox`.`console` (
  `consoleID` char(35) NOT NULL,
  `type` varchar(45) NOT NULL,
  `storage` int(10) unsigned NOT NULL COMMENT 'in gigs',
  PRIMARY KEY  (`consoleID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `xbox`.`control`;
CREATE TABLE  `xbox`.`control` (
  `controlID` char(35) NOT NULL,
  `wireless` tinyint(1) NOT NULL,
  `headset` tinyint(1) NOT NULL,
  PRIMARY KEY  (`controlID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `xbox`.`game`;
CREATE TABLE  `xbox`.`game` (
  `gameID` char(35) NOT NULL,
  `gameName` varchar(100) NOT NULL,
  `specialEdition` tinyint(1) NOT NULL,
  PRIMARY KEY  (`gameID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `xbox`.`relconsoleaccessories`;
CREATE TABLE  `xbox`.`relconsoleaccessories` (
  `consoleID` char(35) NOT NULL,
  `accessoryID` char(35) NOT NULL,
  PRIMARY KEY  (`consoleID`,`accessoryID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `xbox`.`relconsolecontrols`;
CREATE TABLE  `xbox`.`relconsolecontrols` (
  `consoleID` char(35) NOT NULL,
  `controlID` char(35) NOT NULL,
  PRIMARY KEY  (`consoleID`,`controlID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `xbox`.`relconsolegames`;
CREATE TABLE  `xbox`.`relconsolegames` (
  `consoleID` char(35) NOT NULL,
  `gameID` char(35) NOT NULL,
  PRIMARY KEY  (`consoleID`,`gameID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;