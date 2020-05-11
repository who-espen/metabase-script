/*
 * File: duplicates.sql
 * File Created: Monday, 11th May 2020 1:40:17 pm
 * Author: Dyesse YUMBA
 * Last Modified: Monday, 11th May 2020 4:37:30 pm
 * Modified By: Dyesse YUMBA
 * -----
 * (c) 2020, WHO/AFRO/UCN/ESPEN
 */

/*
 * Variable to rename <%metabase_sch_sth_tas_duplicates_202005%>, <%identify_participant_duplicate%>, <%v_ab_cde_fgh_2_participant%>
 * <%ab_cde_fgh_2_participant%>, <%metabase_sch_sth_tas_duplicates_202005_trigger%>, <%identify_kk_result_duplicate%>,
 * <%v_ab_cde_fgh_3_kk%>, <%ab_cde_fgh_3_kk%>, <%metabase_sch_sth_kk_result_duplicates_202004_trigger%>, <%identify_urine_result_duplicate%>
 * <%v_ab_cde_fgh_3_urine%>, <%ab_cde_fgh_3_urine%>
 */

 BEGIN;

/**
* The table to track duplicates issues
*/
CREATE TABLE IF NOT EXISTS <%metabase_sch_sth_tas_duplicates_202005%>(
  id SERIAL PRIMARY KEY,
  id_participant INTEGER NULL, -- The id from participant table
  barcode_participant VARCHAR(255) NULL, -- The barcode from participant table
  id_results INTEGER NULL, -- The id from result table
  barcode_results VARCHAR(255) NULL, -- The barcode from result table
  form VARCHAR(255) NOT NULL,
  status VARCHAR(255) NOT NULL DEFAULT 'Unsolved'
  );

/**
* Adding unique index in the duplicates tables
*/
  CREATE UNIQUE INDEX IF NOT EXISTS idx_duplicates_participant_id_barcode
    ON <%metabase_sch_sth_tas_duplicates_202005%>(id_participant, barcode_participant);
  CREATE UNIQUE INDEX IF NOT EXISTS idx_duplicates_results_id_barcode
    ON <%metabase_sch_sth_tas_duplicates_202005%>(id_results, barcode_results);

  ALTER TABLE <%metabase_sch_sth_tas_duplicates_202005%>
    ADD CONSTRAINT unique_idx_duplicates_participant_id_barcode
    UNIQUE USING INDEX idx_duplicates_participant_id_barcode;

  ALTER TABLE <%metabase_sch_sth_tas_duplicates_202005%>
    ADD CONSTRAINT unique_idx_duplicates_results_id_barcode
    UNIQUE USING INDEX idx_duplicates_results_id_barcode;



/**
* Get all dupplicates records from the participant table and
* and will insert it to the duplicate table created above.
* Returns: trigger
*/
CREATE OR REPLACE FUNCTION <%identify_participant_duplicate%>() RETURNS TRIGGER AS $$
   BEGIN

      IF EXISTS(
        SELECT src.id, src.p_barcode_id FROM <%v_ab_cde_fgh_2_participant%> src
          WHERE src.p_barcode_id = NEW.p_barcode_id
            AND (SELECT count (*)  FROM <%v_ab_cde_fgh_2_participant%> inr WHERE src.p_barcode_id = inr.p_barcode_id ) > 1
            ) THEN

        INSERT INTO <%metabase_sch_sth_tas_duplicates_202005%>(id_participant, barcode_participant, form)
          SELECT id, p_barcode_id, 'Participant'
            FROM (SELECT src.id, src.p_barcode_id FROM <%v_ab_cde_fgh_2_participant%> src
              WHERE src.p_barcode_id = NEW.p_barcode_id) p
          ON CONFLICT ON CONSTRAINT unique_idx_duplicates_participant_id_barcode DO NOTHING;

      END IF;
      RETURN NEW;
   END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER <%metabase_sch_sth_tas_duplicates_202005_trigger%> AFTER INSERT OR UPDATE OR DELETE ON <%ab_cde_fgh_2_participant%>
FOR EACH ROW EXECUTE PROCEDURE <%identify_participant_duplicate%>();



/**
* Query to identifie the existing records with duplicates issues
*/
 INSERT INTO <%metabase_sch_sth_tas_duplicates_202005%>(id_participant, barcode_participant, form)
 SELECT id, p_barcode_id, 'Participant'
            FROM (
              SELECT src.id, src.p_barcode_id FROM <%v_ab_cde_fgh_2_participant%> src
                WHERE (SELECT count (*)  FROM <%v_ab_cde_fgh_2_participant%> inr WHERE src.p_barcode_id = inr.p_barcode_id ) > 1
            ) p

ON CONFLICT ON CONSTRAINT unique_idx_duplicates_participant_id_barcode DO NOTHING;

COMMIT;


/*******************************************************************************************************************************************
 * Kato Katz duplicates
 *******************************************************************************************************************************************/


BEGIN;


/**
* This function to get all dupplicates records from the Kato Katz table and
* and will insert it to the duplicate table created above.
* Returns: trigger
*/
CREATE OR REPLACE FUNCTION <%identify_kk_result_duplicate%>() RETURNS TRIGGER AS $$
   BEGIN

      IF EXISTS(
        SELECT src.id, k_barcode_id FROM <%v_ab_cde_fgh_3_kk%> src
          WHERE k_barcode_id = NEW.k_barcode_id
            AND (SELECT count (*)  FROM <%v_ab_cde_fgh_3_kk%> inr WHERE src.k_barcode_id = inr.k_barcode_id ) > 1
            ) THEN

        INSERT INTO <%metabase_sch_sth_tas_duplicates_202005%>(id_results, barcode_results, form)
          SELECT id, k_barcode_id, 'Kato Katz Results'
            FROM (SELECT src.id, k_barcode_id FROM <%v_ab_cde_fgh_3_kk%> src
              WHERE k_barcode_id = NEW.k_barcode_id) p
          ON CONFLICT ON CONSTRAINT unique_idx_duplicates_results_id_barcode DO NOTHING;

      END IF;
      RETURN NEW;
   END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER <%metabase_sch_sth_kk_result_duplicates_202004_trigger%> AFTER INSERT OR UPDATE OR DELETE ON <%ab_cde_fgh_3_kk%>
FOR EACH ROW EXECUTE PROCEDURE <%identify_kk_result_duplicate%>();

/**
* Query to identifie the existing records with duplicates issues
*/
 INSERT INTO <%metabase_sch_sth_tas_duplicates_202005%>(id_results, barcode_results, form)
 SELECT id, k_barcode_id, 'Kato Katz Results'
            FROM (
              SELECT src.id, src.k_barcode_id FROM <%v_ab_cde_fgh_3_kk%> src
                WHERE (SELECT count (*)  FROM <%v_ab_cde_fgh_3_kk%> inr WHERE src.k_barcode_id = inr.k_barcode_id ) > 1
            ) p

ON CONFLICT ON CONSTRAINT unique_idx_duplicates_results_id_barcode DO NOTHING;


COMMIT;


/*******************************************************************************************************************************************
 * Kato Katz duplicates
 *******************************************************************************************************************************************/

BEGIN;


/**
* This function to get all dupplicates records from the diagnostic table and
* and will insert it to the duplicate table created above.
* Returns: trigger
*/
CREATE OR REPLACE FUNCTION <%identify_urine_result_duplicate%>() RETURNS TRIGGER AS $$
   BEGIN

      IF EXISTS(
        SELECT src.id, u_barcode_id FROM <%v_ab_cde_fgh_3_urine%> src
          WHERE u_barcode_id = NEW.u_barcode_id
            AND (SELECT count (*)  FROM <%v_ab_cde_fgh_3_urine%> inr WHERE src.u_barcode_id = inr.u_barcode_id ) > 1
            ) THEN

        INSERT INTO <%metabase_sch_sth_tas_duplicates_202005%>(id_results, barcode_results, form)
          SELECT id, u_barcode_id, 'Urine Results'
            FROM (SELECT src.id, u_barcode_id FROM <%v_ab_cde_fgh_3_urine%> src
              WHERE u_barcode_id = NEW.u_barcode_id) p
          ON CONFLICT ON CONSTRAINT unique_idx_duplicates_results_id_barcode DO NOTHING;

      END IF;
      RETURN NEW;
   END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER <%metabase_sch_sth_urine_result_duplicates_202004_trigger%> AFTER INSERT OR UPDATE OR DELETE ON <%ab_cde_fgh_3_urine%>
FOR EACH ROW EXECUTE PROCEDURE <%identify_urine_result_duplicate%>();

/**
* Query to identifie the existing records with duplicates issues
*/
 INSERT INTO <%metabase_sch_sth_tas_duplicates_202005%>(id_results, barcode_results, form)
 SELECT id, u_barcode_id, 'Urine Results'
            FROM (
              SELECT src.id, src.u_barcode_id FROM <%v_ab_cde_fgh_3_urine%> src
                WHERE (SELECT count (*)  FROM <%v_ab_cde_fgh_3_urine%> inr WHERE src.u_barcode_id = inr.u_barcode_id ) > 1
            ) p

ON CONFLICT ON CONSTRAINT unique_idx_duplicates_results_id_barcode DO NOTHING;


COMMIT;
