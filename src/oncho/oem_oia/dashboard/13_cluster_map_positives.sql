/*
 * File: 13_cluster_map_positives.sql
 * File Created: Saturday, 2nd May 2020 1:50:50 pm
 * Author: Dyesse YUMBA
 * Last Modified: Saturday, 2nd May 2020 1:53:33 pm
 * Modified By: Dyesse YUMBA
 * -----
 * (c) 2020, WHO/AFRO/UCN/ESPEN
 */

/*
 * This query will will display a pin Map of clusters with positive cases
 * Variable to rename <%ab_cde_fgh_1_cluster%>
 */
 SELECT
  c_district_id,
  c_cluster_id1,
  c_cluster_name,
  c_gps_lat,
  c_gps_lng,
  created_at

FROM <%ab_cde_fgh_1_cluster%> c
LEFT JOIN <%v_ab_cde_fgh_3_rdt_ov16%> d c.c_cluster_id = d.cluster_id

where d_lab_ov16 = '<%Positive%>'

  ------ Metabase filter -------
  -- [[and {{c_cluster_id}}]]
  -- [[and {{cluster_name}}]]
  -- [[and {{district}}]]
  -- [[and {{date}}]]
