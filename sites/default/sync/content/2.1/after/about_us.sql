
START TRANSACTION;

-- Remove existing url alias for "About Us"
DELETE FROM url_alias where alias = '/about-us';

-- Remove existing node for "About Us"
DELETE FROM node WHERE nid = 6;
DELETE FROM node_field_data WHERE nid = 6;
DELETE FROM node_field_revision WHERE nid = 6;
DELETE FROM node__body WHERE entity_id = 6;
DELETE FROM node_revision__body WHERE entity_id = 6;


-- Remove block for "About Us" if it exists
SELECT id FROM block_content_field_data
  WHERE info = 'About Us' LIMIT 1
  INTO @block_id;

DELETE FROM block_content WHERE id = @block_id;
DELETE FROM block_content__body WHERE entity_id  = @block_id;
DELETE FROM block_content_field_data WHERE id = @block_id;
DELETE FROM block_content_field_revision WHERE id = @block_id;
DELETE FROM block_content_revision WHERE id = @block_id;
DELETE FROM block_content_revision__body WHERE entity_id = @block_id;
DELETE FROM config WHERE name = 'block.block.aboutus';

-- Remove block for "Edit About Us Button" if it exists
SELECT id FROM block_content_field_data
  WHERE info = 'Edit About Us Button' LIMIT 1
  INTO @block_id;

DELETE FROM block_content WHERE id = @block_id;
DELETE FROM block_content__body WHERE entity_id  = @block_id;
DELETE FROM block_content_field_data WHERE id = @block_id;
DELETE FROM block_content_field_revision WHERE id = @block_id;
DELETE FROM block_content_revision WHERE id = @block_id;
DELETE FROM block_content_revision__body WHERE entity_id = @block_id;
DELETE FROM config WHERE name = 'block.block.editaboutusbutton';

SELECT AUTO_INCREMENT FROM information_schema.tables
  WHERE table_name='taxonomy_term_data' LIMIT 1
  INTO @term_id;

-- Insert taxonomy term "About Us"
INSERT INTO taxonomy_term_data (tid, vid, uuid, langcode)
  VALUES (@term_id, 'page_specific_tags', UUID(), 'en');

INSERT INTO taxonomy_term_field_data (tid, vid, langcode, name, description__value, description__format, weight, changed, default_langcode)
    VALUES (@term_id, 'page_specific_tags', 'en', 'About Us', NULL, NULL, 0, UNIX_TIMESTAMP(), 1);

INSERT INTO taxonomy_term_hierarchy (tid, parent)
    VALUES (@term_id, 0);

-- Insert basic_node "Our Partners"

SELECT AUTO_INCREMENT FROM information_schema.tables
  WHERE table_name='node' LIMIT 1
  INTO @entity_id;

SELECT AUTO_INCREMENT FROM information_schema.tables
  WHERE table_name='node_revision' LIMIT 1
  INTO @revision_id;

INSERT INTO node (nid, vid, type, uuid, langcode)
  VALUES (@entity_id, @revision_id, 'basic_node', UUID(), 'en');

INSERT INTO node_revision (nid, langcode, revision_timestamp, revision_uid, revision_log, revision_default)
  VALUES (@entity_id, 'en', UNIX_TIMESTAMP(), 2, NULL, 1);

INSERT INTO node_field_data (nid, vid, type, langcode, title, uid, status, created, changed, promote, sticky, revision_translation_affected, default_langcode, ds_switch)
  VALUES (@entity_id, @revision_id, 'basic_node', 'en', 'Our Partners', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 0, 0, 1, 1, NULL);

INSERT INTO node_field_revision (nid, vid, langcode, title, uid, status, created, changed, promote, sticky, revision_translation_affected, default_langcode, ds_switch)
  VALUES (@entity_id, @revision_id, 'en', 'Our Partners', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 0, 0, 1, 1, NULL);

INSERT INTO node__body (bundle, deleted, entity_id, revision_id, langcode, delta, body_value, body_summary, body_format)
  VALUES ('basic_node', 0, @entity_id, @revision_id, 'en', 0, '<p><a href="/partners">ICRP partners</a>&nbsp;represent a wide range of governmental, public and non-profit cancer research funding organizations from across the world.</p>', '', 'full_html');

INSERT INTO node_revision__body (bundle, deleted, entity_id, revision_id, langcode, delta, body_value, body_summary, body_format)
  VALUES ('basic_node', 0, @entity_id, @revision_id, 'en', 0, '<p><a href="/partners">ICRP partners</a>&nbsp;represent a wide range of governmental, public and non-profit cancer research funding organizations from across the world.</p>', '', 'full_html');

INSERT INTO node__field_tags (bundle, deleted, entity_id, revision_id, langcode, delta, field_tags_target_id)
  VALUES ('basic_node', 0, @entity_id, @revision_id, 'en', 0, @term_id);

INSERT INTO node_revision__field_tags (bundle, deleted, entity_id, revision_id, langcode, delta, field_tags_target_id)
  VALUES ('basic_node', 0, @entity_id, @revision_id, 'en', 0, @term_id);



-- Insert basic_node "Our Leadership"

SELECT AUTO_INCREMENT FROM information_schema.tables
  WHERE table_name='node' LIMIT 1
  INTO @entity_id;

SELECT AUTO_INCREMENT FROM information_schema.tables
  WHERE table_name='node_revision' LIMIT 1
  INTO @revision_id;

INSERT INTO node (nid, vid, type, uuid, langcode)
  VALUES (@entity_id, @revision_id, 'basic_node', UUID(), 'en');

INSERT INTO node_revision (nid, langcode, revision_timestamp, revision_uid, revision_log, revision_default)
  VALUES (@entity_id, 'en', UNIX_TIMESTAMP(), 2, NULL, 1);

INSERT INTO node_field_data (nid, vid, type, langcode, title, uid, status, created, changed, promote, sticky, revision_translation_affected, default_langcode, ds_switch)
  VALUES (@entity_id, @revision_id, 'basic_node', 'en', 'Our Leadership', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 0, 0, 1, 1, NULL);

INSERT INTO node_field_revision (nid, vid, langcode, title, uid, status, created, changed, promote, sticky, revision_translation_affected, default_langcode, ds_switch)
  VALUES (@entity_id, @revision_id, 'en', 'Our Leadership', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 0, 0, 1, 1, NULL);

INSERT INTO node__body (bundle, deleted, entity_id, revision_id, langcode, delta, body_value, body_summary, body_format)
  VALUES ('basic_node', 0, @entity_id, @revision_id, 'en', 0, '
<div class="about-us-body">
<dl><dt>Chair</dt>
    <dd>Katherine McKenzie, PhD (California Breast Cancer Research Program, US)</dd>
</dl><dl><dt>Vice-Chair</dt>
    <dd>Naba Bora, PhD (Congressionally Directed Medical Research Programs (CDMRP), U.S. Dept. of Defense)</dd>
</dl><dl><dt>Website &amp; Database Committee</dt>
    <dd>Chair: Michelle Bennett, PhD (NCI Center for Research Strategy, USA)</dd>
</dl><dl><dt>Finance Committee</dt>
    <dd>Chair: Kimberly Badovinac, MA, MBA (Canadian Cancer Research Alliance)</dd>
</dl><dl><dt>Annual Meeting 2017 Committee</dt>
    <dd>Chair: Stuart Griffiths, PhD (National Cancer Research Institute, UK)</dd>
</dl><dl><dt>Operations Committee</dt>
    <dd>Co-Chair: Marion Kavanaugh-Lynch, PhD (California Breast Cancer Research Program, USA)</dd>
</dl><dl><dt>Communications and Membership Committee</dt>
    <dd>Chair: Lisa Stevens, PhD (NCI Center for Global Health, USA)</dd>
    <dd>Vice-Chair: Paul Jackson, PhD (Cancer Australia)</dd>
</dl><dl><dt>Data Quality and Analysis Committee</dt>
    <dd>Chair: Kimberly Badovinac, MA, MBA (Canadian Cancer Research Alliance)</dd>
    <dd>Vice-Chair: Karima Bourougaa, PhD (Institut National du Cancer, France)</dd>
</dl><dl><dt>Evaluations Committee</dt>
    <dd>Chair: Kari Wojtanik, PhD (Susan G. Komen for the Cure)</dd>
</dl><dl><dt>Operations Manager</dt>
    <dd>Lynne Davies, PhD</dd>
</dl></div>', '', 'full_html');

INSERT INTO node_revision__body (bundle, deleted, entity_id, revision_id, langcode, delta, body_value, body_summary, body_format)
  VALUES ('basic_node', 0, @entity_id, @revision_id, 'en', 0, '
<div class="about-us-body">
<dl><dt>Chair</dt>
    <dd>Katherine McKenzie, PhD (California Breast Cancer Research Program, US)</dd>
</dl><dl><dt>Vice-Chair</dt>
    <dd>Naba Bora, PhD (Congressionally Directed Medical Research Programs (CDMRP), U.S. Dept. of Defense)</dd>
</dl><dl><dt>Website &amp; Database Committee</dt>
    <dd>Chair: Michelle Bennett, PhD (NCI Center for Research Strategy, USA)</dd>
</dl><dl><dt>Finance Committee</dt>
    <dd>Chair: Kimberly Badovinac, MA, MBA (Canadian Cancer Research Alliance)</dd>
</dl><dl><dt>Annual Meeting 2017 Committee</dt>
    <dd>Chair: Stuart Griffiths, PhD (National Cancer Research Institute, UK)</dd>
</dl><dl><dt>Operations Committee</dt>
    <dd>Co-Chair: Marion Kavanaugh-Lynch, PhD (California Breast Cancer Research Program, USA)</dd>
</dl><dl><dt>Communications and Membership Committee</dt>
    <dd>Chair: Lisa Stevens, PhD (NCI Center for Global Health, USA)</dd>
    <dd>Vice-Chair: Paul Jackson, PhD (Cancer Australia)</dd>
</dl><dl><dt>Data Quality and Analysis Committee</dt>
    <dd>Chair: Kimberly Badovinac, MA, MBA (Canadian Cancer Research Alliance)</dd>
    <dd>Vice-Chair: Karima Bourougaa, PhD (Institut National du Cancer, France)</dd>
</dl><dl><dt>Evaluations Committee</dt>
    <dd>Chair: Kari Wojtanik, PhD (Susan G. Komen for the Cure)</dd>
</dl><dl><dt>Operations Manager</dt>
    <dd>Lynne Davies, PhD</dd>
</dl></div>', '', 'full_html');

INSERT INTO node__field_tags (bundle, deleted, entity_id, revision_id, langcode, delta, field_tags_target_id)
  VALUES ('basic_node', 0, @entity_id, @revision_id, 'en', 0, @term_id);

INSERT INTO node_revision__field_tags (bundle, deleted, entity_id, revision_id, langcode, delta, field_tags_target_id)
  VALUES ('basic_node', 0, @entity_id, @revision_id, 'en', 0, @term_id);



-- Insert basic_node "Our Partner Representatives"

SELECT AUTO_INCREMENT FROM information_schema.tables
  WHERE table_name='node' LIMIT 1
  INTO @entity_id;

SELECT AUTO_INCREMENT FROM information_schema.tables
  WHERE table_name='node_revision' LIMIT 1
  INTO @revision_id;

INSERT INTO node (nid, vid, type, uuid, langcode)
  VALUES (@entity_id, @revision_id, 'basic_node', UUID(), 'en');

INSERT INTO node_revision (nid, langcode, revision_timestamp, revision_uid, revision_log, revision_default)
  VALUES (@entity_id, 'en', UNIX_TIMESTAMP(), 2, NULL, 1);

INSERT INTO node_field_data (nid, vid, type, langcode, title, uid, status, created, changed, promote, sticky, revision_translation_affected, default_langcode, ds_switch)
  VALUES (@entity_id, @revision_id, 'basic_node', 'en', 'Our Partner Representatives', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 0, 0, 1, 1, NULL);

INSERT INTO node_field_revision (nid, vid, langcode, title, uid, status, created, changed, promote, sticky, revision_translation_affected, default_langcode, ds_switch)
  VALUES (@entity_id, @revision_id, 'en', 'Our Partner Representatives', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP(), 0, 0, 1, 1, NULL);

INSERT INTO node__body (bundle, deleted, entity_id, revision_id, langcode, delta, body_value, body_summary, body_format)
  VALUES ('basic_node', 0, @entity_id, @revision_id, 'en', 0, '<div class="about-us-body">
<p>Each partner organization designates one or more person as an official contact for the ICRP and these individuals are listed below. Multiple staff members from organizations are welcome to participate in ICRP events, activities and projects.</p>

<div>
<table class="table table-bordered"><thead><tr><th style="width: 50%">USA</th>
            <th style="width: 50%">Representatives</th>
        </tr></thead><tbody><tr><td>American Institute for Cancer Research (AICR)</td>
            <td>Nigel Brockton, PhD</td>
        </tr><tr><td>American Cancer Society (ACS)</td>
            <td>Cheri Richard, MS<br>
            T.J. Koerner, PhD<br>
            Erin Stratton, MPH</td>
        </tr><tr><td>American Society for Radiation Oncology (ASTRO)</td>
            <td>Judy Keen, PhD<br>
            Tyler Beck, PhD</td>
        </tr><tr><td>Avon Breast Cancer Crusade (Avon)</td>
            <td>Carolyn Ricci</td>
        </tr><tr><td>California Breast Cancer Research Program (CBCRP)</td>
            <td>Mhel Kavanaugh-Lynch, MD, MPH<br>
            Katie McKenzie, PhD<br>
            Senaida Poole, PhD</td>
        </tr><tr><td>Coalition Against Childhood Cancer (CAC2) – representing over 10 funding organizations</td>
            <td>Lisa Towry</td>
        </tr><tr><td>Congressionally Directed Medical Research Programs (CDMRP), U.S. Dept. of Defense</td>
            <td>Naba Bora, PhD</td>
        </tr><tr><td>National Cancer Institute (NCI) - Center for Research Strategy</td>
            <td>Michelle Bennett, PhD<br>
            Eddie Billingslea, PhD<br>
            Melissa Antman, PhD<br>
            Laura Brockway Lunardi, PhD</td>
        </tr><tr><td>National Cancer Institute (NCI) / DEA/RAEB</td>
            <td>Marilyn Gaston<br>
            Ed Kyle<br>
            Beth Buschling</td>
        </tr><tr><td>National Cancer Institute (NCI) - Center for Global Health</td>
            <td>Lisa Stevens, PhD<br>
            Rachel Abudu, MPH (Leidos Biomedical Research Inc.)<br>
            Douglas Puricelli Perin, MPH, JD (Leidos Biomedical Research, Inc.)<br>
            Kalina Duncan, PhD</td>
        </tr><tr><td>Oncology Nursing Society Foundation (ONS)</td>
            <td>Linda Worrall, RN, MSN</td>
        </tr><tr><td>Pancreatic Cancer Action Network (Pancan)</td>
            <td>Donna Manross, BS<br>
            Maya Bader, PhD</td>
        </tr><tr><td>Susan G. Komen® (Komen)</td>
            <td>Stephanie Birkey-Reffey, PhD<br>
            Kari Wojtanik, PhD<br>
            Jerome Jourquin, PhD<br>
            Annabel Oh, PhD</td>
        </tr></tbody></table><table class="table table-bordered"><thead><tr><th style="width: 50%">Canada</th>
            <th style="width: 50%">Representatives</th>
        </tr></thead><tbody><tr><td>Canadian Cancer Research Alliance (CCRA) Representing 42 Canadian cancer organizations</td>
            <td>Kim Badovinac, MA, MBA</td>
        </tr></tbody></table><table class="table table-bordered"><thead><tr><th style="width: 50%">Netherlands</th>
            <th style="width: 50%">Representatives</th>
        </tr></thead><tbody><tr><td>Dutch Cancer Society / Kankerbestrijding (KWF)</td>
            <td>Annemarie Weerman, PhD</td>
        </tr></tbody></table><table class="table table-bordered"><thead><tr><th style="width: 50%">France</th>
            <th style="width: 50%">Representatives</th>
        </tr></thead><tbody><tr><td>French National Cancer Institute / Institut National du Cancer (INCa)</td>
            <td>Karima Bourougaa, PhD</td>
        </tr></tbody></table><table class="table table-bordered"><thead><tr><th style="width: 50%">UK</th>
            <th style="width: 50%">Representatives</th>
        </tr></thead><tbody><tr><td>National Cancer Research Institute (NCRI) Representing over 20 UK funders</td>
            <td>Stuart Griffiths, PhD<br>
            Sam Gibbons Frendo</td>
        </tr></tbody></table><table class="table table-bordered"><thead><tr><th style="width: 50%">Japan</th>
            <th style="width: 50%">Representatives</th>
        </tr></thead><tbody><tr><td>National Cancer Center (NCC) Japan</td>
            <td>Toshio Ogawa, MSc, PhD<br>
            Teruhiko Yoshida</td>
        </tr></tbody></table><table class="table table-bordered"><thead><tr><th style="width: 50%">Australia</th>
            <th style="width: 50%">Representatives</th>
        </tr></thead><tbody><tr><td>Cancer Institute New South Wales (CINSW)</td>
            <td>Veronica McCabe, PhD<br>
            Emma Heeley, PhD</td>
        </tr><tr><td>Cancer Australia (CancerAust)</td>
            <td>Paul Jackson, PhD</td>
        </tr><tr><td>National Breast Cancer Foundation (NBCF)</td>
            <td>Chris Pettigrew, PhD</td>
        </tr></tbody></table><table class="table table-bordered"><thead><tr><th style="width: 50%">International</th>
            <th style="width: 50%">Representatives</th>
        </tr></thead><tbody><tr><td>World Cancer Research Fund International</td>
            <td>Giota Mitrou, PhD<br>
            Anna Diaz Font, PhD</td>
        </tr></tbody></table></div>
</div>', '', 'full_html');

INSERT INTO node_revision__body (bundle, deleted, entity_id, revision_id, langcode, delta, body_value, body_summary, body_format)
  VALUES ('basic_node', 0, @entity_id, @revision_id, 'en', 0, '<div class="about-us-body">
<p>Each partner organization designates one or more person as an official contact for the ICRP and these individuals are listed below. Multiple staff members from organizations are welcome to participate in ICRP events, activities and projects.</p>

<div>
<table class="table table-bordered"><thead><tr><th style="width: 50%">USA</th>
            <th style="width: 50%">Representatives</th>
        </tr></thead><tbody><tr><td>American Institute for Cancer Research (AICR)</td>
            <td>Nigel Brockton, PhD</td>
        </tr><tr><td>American Cancer Society (ACS)</td>
            <td>Cheri Richard, MS<br>
            T.J. Koerner, PhD<br>
            Erin Stratton, MPH</td>
        </tr><tr><td>American Society for Radiation Oncology (ASTRO)</td>
            <td>Judy Keen, PhD<br>
            Tyler Beck, PhD</td>
        </tr><tr><td>Avon Breast Cancer Crusade (Avon)</td>
            <td>Carolyn Ricci</td>
        </tr><tr><td>California Breast Cancer Research Program (CBCRP)</td>
            <td>Mhel Kavanaugh-Lynch, MD, MPH<br>
            Katie McKenzie, PhD<br>
            Senaida Poole, PhD</td>
        </tr><tr><td>Coalition Against Childhood Cancer (CAC2) – representing over 10 funding organizations</td>
            <td>Lisa Towry</td>
        </tr><tr><td>Congressionally Directed Medical Research Programs (CDMRP), U.S. Dept. of Defense</td>
            <td>Naba Bora, PhD</td>
        </tr><tr><td>National Cancer Institute (NCI) - Center for Research Strategy</td>
            <td>Michelle Bennett, PhD<br>
            Eddie Billingslea, PhD<br>
            Melissa Antman, PhD<br>
            Laura Brockway Lunardi, PhD</td>
        </tr><tr><td>National Cancer Institute (NCI) / DEA/RAEB</td>
            <td>Marilyn Gaston<br>
            Ed Kyle<br>
            Beth Buschling</td>
        </tr><tr><td>National Cancer Institute (NCI) - Center for Global Health</td>
            <td>Lisa Stevens, PhD<br>
            Rachel Abudu, MPH (Leidos Biomedical Research Inc.)<br>
            Douglas Puricelli Perin, MPH, JD (Leidos Biomedical Research, Inc.)<br>
            Kalina Duncan, PhD</td>
        </tr><tr><td>Oncology Nursing Society Foundation (ONS)</td>
            <td>Linda Worrall, RN, MSN</td>
        </tr><tr><td>Pancreatic Cancer Action Network (Pancan)</td>
            <td>Donna Manross, BS<br>
            Maya Bader, PhD</td>
        </tr><tr><td>Susan G. Komen® (Komen)</td>
            <td>Stephanie Birkey-Reffey, PhD<br>
            Kari Wojtanik, PhD<br>
            Jerome Jourquin, PhD<br>
            Annabel Oh, PhD</td>
        </tr></tbody></table><table class="table table-bordered"><thead><tr><th style="width: 50%">Canada</th>
            <th style="width: 50%">Representatives</th>
        </tr></thead><tbody><tr><td>Canadian Cancer Research Alliance (CCRA) Representing 42 Canadian cancer organizations</td>
            <td>Kim Badovinac, MA, MBA</td>
        </tr></tbody></table><table class="table table-bordered"><thead><tr><th style="width: 50%">Netherlands</th>
            <th style="width: 50%">Representatives</th>
        </tr></thead><tbody><tr><td>Dutch Cancer Society / Kankerbestrijding (KWF)</td>
            <td>Annemarie Weerman, PhD</td>
        </tr></tbody></table><table class="table table-bordered"><thead><tr><th style="width: 50%">France</th>
            <th style="width: 50%">Representatives</th>
        </tr></thead><tbody><tr><td>French National Cancer Institute / Institut National du Cancer (INCa)</td>
            <td>Karima Bourougaa, PhD</td>
        </tr></tbody></table><table class="table table-bordered"><thead><tr><th style="width: 50%">UK</th>
            <th style="width: 50%">Representatives</th>
        </tr></thead><tbody><tr><td>National Cancer Research Institute (NCRI) Representing over 20 UK funders</td>
            <td>Stuart Griffiths, PhD<br>
            Sam Gibbons Frendo</td>
        </tr></tbody></table><table class="table table-bordered"><thead><tr><th style="width: 50%">Japan</th>
            <th style="width: 50%">Representatives</th>
        </tr></thead><tbody><tr><td>National Cancer Center (NCC) Japan</td>
            <td>Toshio Ogawa, MSc, PhD<br>
            Teruhiko Yoshida</td>
        </tr></tbody></table><table class="table table-bordered"><thead><tr><th style="width: 50%">Australia</th>
            <th style="width: 50%">Representatives</th>
        </tr></thead><tbody><tr><td>Cancer Institute New South Wales (CINSW)</td>
            <td>Veronica McCabe, PhD<br>
            Emma Heeley, PhD</td>
        </tr><tr><td>Cancer Australia (CancerAust)</td>
            <td>Paul Jackson, PhD</td>
        </tr><tr><td>National Breast Cancer Foundation (NBCF)</td>
            <td>Chris Pettigrew, PhD</td>
        </tr></tbody></table><table class="table table-bordered"><thead><tr><th style="width: 50%">International</th>
            <th style="width: 50%">Representatives</th>
        </tr></thead><tbody><tr><td>World Cancer Research Fund International</td>
            <td>Giota Mitrou, PhD<br>
            Anna Diaz Font, PhD</td>
        </tr></tbody></table></div>
</div>', '', 'full_html');

INSERT INTO node__field_tags (bundle, deleted, entity_id, revision_id, langcode, delta, field_tags_target_id)
  VALUES ('basic_node', 0, @entity_id, @revision_id, 'en', 0, @term_id);

INSERT INTO node_revision__field_tags (bundle, deleted, entity_id, revision_id, langcode, delta, field_tags_target_id)
  VALUES ('basic_node', 0, @entity_id, @revision_id, 'en', 0, @term_id);

COMMIT;
