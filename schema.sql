-- Drop Tables If Exists Already
DROP TABLE "routes";
DROP TABLE "services";
DROP TABLE "operators";
DROP TABLE "complaints";

-- Creating Table 'Routes'
CREATE TABLE "routes" AS (
    "id" INTEGER,
    "type" TEXT NOT NULL CHECK("type" IN ('Bus', 'Trolley', 'Subway', 'Rail')),
    "route_name" TEXT NOT NULL UNIQUE,
    "services_per_day" INTEGER NOT NULL,
    "drivers_per_route" INTEGER NOT NULL,
    "number_of_stops" INTEGER NOT NULL,
    "capacity" INTEGER NOT NULL,
    "fare" NUMERIC NOT NULL CHECK("fare" != 0),
    PRIMARY KEY("id")
);

-- Creating Table 'Routes'
CREATE TABLE "services" AS (
    "id" INTEGER,
    "route_id" INTEGER,
    "service_number" TEXT NOT NULL,
    "driver_id" INTEGER NOT NULL,
    "service_expected_start_time" NUMERIC NOT NULL DEFAULT CURRENT TIMESTAMP,
    "service_expected_end_time" NUMERIC NOT NULL DEFAULT CURRENT TIMESTAMP,
    "service_actual_start_time" NUMERIC NOT NULL DEFAULT CURRENT TIMESTAMP,
    "service_actual_end_time" NUMERIC NOT NULL DEFAULT CURRENT TIMESTAMP,
    "number_of_passangers" INTEGER NOT NULL,
    "is_delayed" TEXT NOT NULL CHECK("is_delayed" IN ("Yes", "No")),
    "service_comments" TEXT,
    PRIMARY KEY("id"),
    FOREIGN KEY("route_id") REFERENCES "routes"("id"),
    FOREIGN KEY("driver_id") REFERENCES "operators"("id")
);

-- Creating Table 'Operators'
CREATE TABLE "operators" AS (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "salary" NUMERIC NOT NULL CHECK("fare" != 0),
    "tenure" NUMERIC NOT NULL,
    PRIMARY KEY("id")
);

-- Creating Table 'Complaints'
CREATE TABLE "complaints" AS (
    "id" INTEGER,
    "service_id" INTEGER,
    "service_date" NUMERIC NOT NULL DEFAULT CURRENT TIMESTAMP,
    "complaint_log_date" NUMERIC NOT NULL DEFAULT CURRENT TIMESTAMP,
    "onboard_stop" TEXT NOT NULL,
    "off_board_stop" TEXT NOT NULL,
    "complaint" TEXT NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("service_id") REFERENCES "routes"("id")
);


-- View to capute operator performance.
CREATE VIEW "operator_performance" AS
SELECT
    "operators"."first_name",
    "operators"."last_name",
    COUNT("services"."id") AS "total_services",
    SUM(CASE WHEN "services"."is_delayed" = 'Yes' THEN 1 ELSE 0 END) AS "delays",
    AVG("services"."number_of_passenger", 2) AS "avg_passengers"
FROM "operators"
JOIN "services" ON "services"."driver_id" = "operators"."id"
GROUP BY "operators"."first_name", "operators"."last_name"
;

-- Create indexes to speed common searches
CREATE INDEX "services_routes" ON "services"("route_id");
CREATE INDEX "service_complaints" ON "complaints"("service_id");



