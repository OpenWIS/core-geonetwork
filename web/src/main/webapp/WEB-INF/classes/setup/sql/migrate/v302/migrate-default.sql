INSERT INTO MetadataIdentifierTemplate (id, name, template, isprovided) VALUES  (0, 'Custom URN', '', 'y');
INSERT INTO MetadataIdentifierTemplate (id, name, template, isprovided) VALUES  (1, 'Autogenerated URN', '', 'y');

INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('metadata/workflow/draftWhenInGroup', '', 0, 100002, 'n');
INSERT INTO Settings (name, value, datatype, position, internal) VALUES ('system/oai/maxrecords', '10', 1, 7040, 'y');

-- ALTER TABLE groups ALTER COLUMN email TYPE varchar(128);

UPDATE Settings SET value='3.0.2' WHERE name='system/platform/version';
UPDATE Settings SET value='SNAPSHOT' WHERE name='system/platform/subVersion';
