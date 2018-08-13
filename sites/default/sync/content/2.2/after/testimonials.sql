

-- Insert testimonial 1

SELECT AUTO_INCREMENT FROM information_schema.tables
  WHERE table_name=`node`
  INTO @entity_id;

SELECT AUTO_INCREMENT FROM information_schema.tables
  WHERE table_name=`node_revision`
  INTO @revision_id;

INSERT INTO node (nid, vid, type, uuid, langcode)
  VALUES (@entity_id, @revision_id, `testimonial`, UUID(), `en`);

INSERT INTO node_revision (nid, langcode, revision_timestamp, revision_uid, revision_log, revision_default)
  VALUES (@entity_id, `en`, UNIX_TIMESTAMP(), 2, NULL, 1);

INSERT INTO node_field_data (nid, vid, type, langcode, title, uid, status, created, changed, promote, sticky, revision_translation_affected, default_langcode, ds_switch)
  VALUES (@entity_id, @revision_id, `testimonial`, `en`, `1`, 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 0, 0, 1, 1, NULL);

INSERT INTO node_field_revision (nid, vid, langcode, title, uid, status, created, changed, promote, sticky, revision_translation_affected, default_langcode, ds_switch)
  VALUES (@entity_id, @revision_id, `en`, `1`, 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 0, 0, 1, 1, NULL);

INSERT INTO node__body (bundle, deleted, entity_id, revision_id, langcode, delta, body_value, body_summary, body_format)
  VALUES (`testimonial`,0,@entity_id, @revision_id,`en`,0,`<p>“Less than an hour since arriving at #ICRP2018 annual meeting and have already had a breakfast convo about a potential international collaboration. Living the @icrpartners1 mission!”<br />\r\n&nbsp;</p>\r\n`,``,`basic_html`);

INSERT INTO node_revision__body (bundle, deleted, entity_id, revision_id, langcode, delta, body_value, body_summary, body_format)
  VALUES (`testimonial`,0,@entity_id, @revision_id,`en`,0,`<p>“Less than an hour since arriving at #ICRP2018 annual meeting and have already had a breakfast convo about a potential international collaboration. Living the @icrpartners1 mission!”<br />\r\n&nbsp;</p>\r\n`,``,`basic_html`);

INSERT INTO `node__field_source` (bundle, deleted, entity_id, revision_id, langcode, delta, field_source_value)
  VALUES (`testimonial`,0,@entity_id, @revision_id,`en`,0,`@DrHelenRippon (Worldwide Cancer Research)`);

INSERT INTO `node_revision__field_source` (bundle, deleted, entity_id, revision_id, langcode, delta, field_source_value)
  VALUES (`testimonial`,0,@entity_id, @revision_id,`en`,0,`@DrHelenRippon (Worldwide Cancer Research)`);

INSERT INTO `node_access` (nid, langcode, fallback, gid, realm, grant_view, grant_update, grant_delete)
	VALUES (@entity_id,`en`,1,0,`all`,1,0,0)

-- Insert testimonial 2

SELECT AUTO_INCREMENT FROM information_schema.tables
  WHERE table_name=`node`
  INTO @entity_id;

SELECT AUTO_INCREMENT FROM information_schema.tables
  WHERE table_name=`node_revision`
  INTO @revision_id;

INSERT INTO node (nid, vid, type, uuid, langcode)
  VALUES (@entity_id, @revision_id, `testimonial`, UUID(), `en`);

INSERT INTO node_revision (nid, langcode, revision_timestamp, revision_uid, revision_log, revision_default)
  VALUES (@entity_id, `en`, UNIX_TIMESTAMP(), 2, NULL, 1);

INSERT INTO node_field_data (nid, vid, type, langcode, title, uid, status, created, changed, promote, sticky, revision_translation_affected, default_langcode, ds_switch)
  VALUES (@entity_id, @revision_id, `testimonial`, `en`, `2`, 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 0, 0, 1, 1, NULL);

INSERT INTO node_field_revision (nid, vid, langcode, title, uid, status, created, changed, promote, sticky, revision_translation_affected, default_langcode, ds_switch)
  VALUES (@entity_id, @revision_id, `en`, `2`, 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 0, 0, 1, 1, NULL);

INSERT INTO node__body (bundle, deleted, entity_id, revision_id, langcode, delta, body_value, body_summary, body_format)
  VALUES (`testimonial`,0,@entity_id, @revision_id,`en`,0,`<p>“ICRP’s Environmental Influences on Breast Cancer report highlighted that investment in this area was declining. Over the time period studied, the numbers of active awards declined and funding levels also fell, both in absolute terms, and as a percentage of the overall breast cancer portfolio. Using these data, and other evidence, CBCRP was able to promote additional research and capacity building in this area.”<br />\r\n&nbsp;</p>\r\n`,``,`basic_html`);

INSERT INTO node_revision__body (bundle, deleted, entity_id, revision_id, langcode, delta, body_value, body_summary, body_format)
  VALUES   (`testimonial`,0,@entity_id, @revision_id,`en`,0,`<p>“ICRP’s Environmental Influences on Breast Cancer report highlighted that investment in this area was declining. Over the time period studied, the numbers of active awards declined and funding levels also fell, both in absolute terms, and as a percentage of the overall breast cancer portfolio. Using these data, and other evidence, CBCRP was able to promote additional research and capacity building in this area.”<br />\r\n&nbsp;</p>\r\n`,``,`basic_html`);

INSERT INTO `node__field_source` (bundle, deleted, entity_id, revision_id, langcode, delta, field_source_value)
  VALUES (`testimonial`,0,@entity_id, @revision_id,`en`,0,`Dr Mhel Kavanaugh-Lynch, California Breast Cancer Research Program`);

INSERT INTO `node_revision__field_source` (bundle, deleted, entity_id, revision_id, langcode, delta, field_source_value)
  VALUES (`testimonial`,0,@entity_id, @revision_id,`en`,0,`Dr Mhel Kavanaugh-Lynch, California Breast Cancer Research Program`);

INSERT INTO `node_access` (nid, langcode, fallback, gid, realm, grant_view, grant_update, grant_delete)
	VALUES (@entity_id,`en`,1,0,`all`,1,0,0)

-- Insert testimonial 3

SELECT AUTO_INCREMENT FROM information_schema.tables
  WHERE table_name=`node`
  INTO @entity_id;

SELECT AUTO_INCREMENT FROM information_schema.tables
  WHERE table_name=`node_revision`
  INTO @revision_id;

INSERT INTO node (nid, vid, type, uuid, langcode)
  VALUES (@entity_id, @revision_id, `testimonial`, UUID(), `en`);

INSERT INTO node_revision (nid, langcode, revision_timestamp, revision_uid, revision_log, revision_default)
  VALUES (@entity_id, `en`, UNIX_TIMESTAMP(), 2, NULL, 1);

INSERT INTO node_field_data (nid, vid, type, langcode, title, uid, status, created, changed, promote, sticky, revision_translation_affected, default_langcode, ds_switch)
  VALUES (@entity_id, @revision_id, `testimonial`, `en`, `3`, 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 0, 0, 1, 1, NULL);

INSERT INTO node_field_revision (nid, vid, langcode, title, uid, status, created, changed, promote, sticky, revision_translation_affected, default_langcode, ds_switch)
  VALUES (@entity_id, @revision_id, `en`, `3`, 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 0, 0, 1, 1, NULL);

INSERT INTO node__body (bundle, deleted, entity_id, revision_id, langcode, delta, body_value, body_summary, body_format)
  VALUES (`testimonial`,0,@entity_id, @revision_id,`en`,0,`<p>“ICRP worked with the Metastatic Breast Cancer Alliance to provide data for a landscape analysis of metastatic breast cancer research, helping the Alliance realize it’s vision of improving outcomes for women with metastatic breast cancer”<br />\r\n&nbsp;</p>\r\n`,``,`basic_html`);

INSERT INTO node_revision__body (bundle, deleted, entity_id, revision_id, langcode, delta, body_value, body_summary, body_format)
  VALUES (`testimonial`,0,@entity_id, @revision_id,`en`,0,`<p>“ICRP worked with the Metastatic Breast Cancer Alliance to provide data for a landscape analysis of metastatic breast cancer research, helping the Alliance realize it’s vision of improving outcomes for women with metastatic breast cancer”<br />\r\n&nbsp;</p>\r\n`,``,`basic_html`);

INSERT INTO `node__field_source` (bundle, deleted, entity_id, revision_id, langcode, delta, field_source_value)
  VALUES (`testimonial`,0,@entity_id, @revision_id,`en`,0,`Dr Marc Hurlbert, Metastatic Breast Cancer Alliance`);

INSERT INTO `node_revision__field_source` (bundle, deleted, entity_id, revision_id, langcode, delta, field_source_value)
  VALUES (`testimonial`,0,@entity_id, @revision_id,`en`,0,`Dr Marc Hurlbert, Metastatic Breast Cancer Alliance`);

INSERT INTO `node_access` (nid, langcode, fallback, gid, realm, grant_view, grant_update, grant_delete)
	VALUES (@entity_id,`en`,1,0,`all`,1,0,0)

-- Insert testimonial 4

SELECT AUTO_INCREMENT FROM information_schema.tables
  WHERE table_name=`node`
  INTO @entity_id;

SELECT AUTO_INCREMENT FROM information_schema.tables
  WHERE table_name=`node_revision`
  INTO @revision_id;

INSERT INTO node (nid, vid, type, uuid, langcode)
  VALUES (@entity_id, @revision_id, `testimonial`, UUID(), `en`);

INSERT INTO node_revision (nid, langcode, revision_timestamp, revision_uid, revision_log, revision_default)
  VALUES (@entity_id, `en`, UNIX_TIMESTAMP(), 2, NULL, 1);

INSERT INTO node_field_data (nid, vid, type, langcode, title, uid, status, created, changed, promote, sticky, revision_translation_affected, default_langcode, ds_switch)
  VALUES (@entity_id, @revision_id, `testimonial`, `en`, `4`, 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 0, 0, 1, 1, NULL);

INSERT INTO node_field_revision (nid, vid, langcode, title, uid, status, created, changed, promote, sticky, revision_translation_affected, default_langcode, ds_switch)
  VALUES (@entity_id, @revision_id, `en`, `4`, 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 0, 0, 1, 1, NULL);

INSERT INTO node__body (bundle, deleted, entity_id, revision_id, langcode, delta, body_value, body_summary, body_format)
  VALUES   (`testimonial`,0,@entity_id, @revision_id,`en`,0,`<p>“Analysis of the national portfolio using the ICRP’s CSO coding system highlighted low investment in prevention research in the UK in 2004. As a result of the analysis, UK health research funders collaborated to fund over £34m and over 70 projects in prevention research to boost research capacity in this area.”<br />\r\n&nbsp;</p>\r\n`,``,`basic_html`);

INSERT INTO node_revision__body (bundle, deleted, entity_id, revision_id, langcode, delta, body_value, body_summary, body_format)
  VALUES   (`testimonial`,0,@entity_id, @revision_id,`en`,0,`<p>“Analysis of the national portfolio using the ICRP’s CSO coding system highlighted low investment in prevention research in the UK in 2004. As a result of the analysis, UK health research funders collaborated to fund over £34m and over 70 projects in prevention research to boost research capacity in this area.”<br />\r\n&nbsp;</p>\r\n`,``,`basic_html`);

INSERT INTO `node__field_source` (bundle, deleted, entity_id, revision_id, langcode, delta, field_source_value)
  VALUES (`testimonial`,0,@entity_id, @revision_id,`en`,0,`UK National Cancer Research Institute`);

INSERT INTO `node_revision__field_source` (bundle, deleted, entity_id, revision_id, langcode, delta, field_source_value)
  VALUES (`testimonial`,0,@entity_id, @revision_id,`en`,0,`UK National Cancer Research Institute`);

INSERT INTO `node_access` (nid, langcode, fallback, gid, realm, grant_view, grant_update, grant_delete)
	VALUES (@entity_id,`en`,1,0,`all`,1,0,0)
