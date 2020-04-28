/*
 * File: 3_number_duplicate_per_day.sql
 * File Created: Tuesday, 28th April 2020 4:52:58 pm
 * Author: Dyesse YUMBA
 * Last Modified: Tuesday, 28th April 2020 4:56:50 pm
 * Modified By: Dyesse YUMBA
 * -----
 * (c) 2020, WHO/AFRO/UCN/ESPEN
 */


/*
 * A query to display the total records of duplicates per day
 * Variable to rename <%matabase_oncho_oem_duplicates_202004%>, <%v_ab_cde_fgh_3_participant%>
 */
 SELECT
 COUNT(barcode_participant),
 p.p_date::date
FROM <%matabase_oncho_oem_duplicates_202004%> AS m, <%v_ab_cde_fgh_3_participant%> AS p
WHERE m.id IS NOT NULL AND m.id_participant = p.id

GROUP BY p.p_date::DATE

UNION ALL

SELECT
 COUNT(barcode_participant),
 d.p_date::date
FROM <%matabase_oncho_oem_duplicates_202004%> AS m, <%v_ab_cde_fgh_3_rdt_ov16%> AS d
WHERE m.id IS NOT NULL AND m.id_results = d.id

GROUP BY d.d_date::DATE
