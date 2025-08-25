-- Find the top 15 routes with the most services.
-- Order them highest to lowest by services per day, then by number of stops per route.
-- Count the number of complaints submitted for each route.
SELECT "routes"."type", "routes"."route_name", "routes"."services_per_day", "routes"."drivers_per_route", "routes"."number_of_stops", "routes"."capacity",
    "routes"."fare", COUNT("complaints"."id") AS "complaint_count"
FROM "routes"
JOIN "complaints" ON "complaints"."service_id" = "routes"."id"
GROUP BY "routes"."id"
ORDER BY "routes"."services_per_day" DESC, "routes"."number_of_stops" DESC
LIMIT 15
;

-- Test to see if the 'services' table accurately calculates the 'is_delayed' column.
SELECT
    "route_id",
    "service_number",
    "driver_id",
    TIMESTAMPDIFF(MINUTE, "service_expected_start_time", "service_actual_start_time") AS "start_time_diff",
    CASE
        WHEN "start_time_diff" > 0
            THEN 'Yes'
        ELSE 'No'
    END AS "start_delay",
    TIMESTAMPDIFF(MINUTE, "service_expected_end_time", "service_actual_end_time") AS "end_time_diff",
    CASE
        WHEN "end_time_diff" > 0
            THEN 'Yes'
        ELSE 'No'
    END AS "end_delay",
    "is_delayed"
FROM "services"
;

-- Find the average number of passangers per route and compare it to the route capacity.
-- Also calculate the gross fare amount for each route per day (based on the average passanger count).
SELECT
    "routes"."route_name",
    "routes"."type",
    "routes"."capacity",
    AVG("services"."number_of_passenger", 2) AS "average_num_passengers"
    "routes"."fare" * "average_num_passengers" AS "gross_profits"
FROM "routes"
JOIN "services" ON "services"."route_id" = "routes"."id"
GROUP BY "services"."route_id"
ORDER BY "routes"."type" ASC, "routes"."name" ASC
;

-- Add a new operator.
INSERT INTO "operators" ("first_name", "last_name", "salary", "tenure")
VALUES ('John', 'Smith', '50000.00', '0')
;

-- Delete the Wilmington/Newark Regional Rail route being cut.
DELETE FROM "routes"
WHERE "route_name" IN ('WIL S', 'WIL N')
;
