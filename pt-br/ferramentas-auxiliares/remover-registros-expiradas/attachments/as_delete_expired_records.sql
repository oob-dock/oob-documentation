CREATE OR REPLACE PROCEDURE as_delete_expired_records()
LANGUAGE plpgsql
AS $$
DECLARE
    expiration_time TIMESTAMP;
    rows_deleted INT;
	batch_size INT;
BEGIN
    expiration_time := NOW() - INTERVAL '7 month';
	batch_size := 50000;

    LOOP
        DELETE FROM "Interactions" i 
        USING (
            SELECT i."id", i."brandId" 
            FROM "Interactions" i 
            WHERE i."expiresAt" < expiration_time 
            LIMIT batch_size
        ) AS subquery 
        WHERE subquery."id" = i."id" 
        AND subquery."brandId" = i."brandId";

        -- Get the number of rows deleted
        GET DIAGNOSTICS rows_deleted = ROW_COUNT;
        COMMIT;  -- Commit after each batch
        EXIT WHEN rows_deleted = 0;
    END LOOP;

    LOOP
        DELETE FROM "HandoffEvents" he 
        USING (
            SELECT he."id", he."brandId" 
            FROM "HandoffEvents" he 
            WHERE he."createdAt" < expiration_time 
            LIMIT batch_size
        ) AS subquery 
        WHERE subquery."id" = he."id" 
        AND subquery."brandId" = he."brandId";

        GET DIAGNOSTICS rows_deleted = ROW_COUNT;
        COMMIT;
        EXIT WHEN rows_deleted = 0;
    END LOOP;

    LOOP
        DELETE FROM "HandoffTypeCodes" htc 
        USING (
            SELECT htc."id", htc."brandId" 
            FROM "HandoffTypeCodes" htc 
            WHERE htc."expiresAt" < expiration_time 
            LIMIT batch_size
        ) AS subquery 
        WHERE subquery."id" = htc."id" 
        AND subquery."brandId" = htc."brandId";

        GET DIAGNOSTICS rows_deleted = ROW_COUNT;
        COMMIT;
        EXIT WHEN rows_deleted = 0;
    END LOOP;

	LOOP
        DELETE FROM "Commands" c 
        USING (
            SELECT c."id", c."brandId" 
            FROM "Commands" c 
            WHERE c."createdAt" < expiration_time
				and not exists (SELECT 1 from "HandoffTypeCodes" htc where c."id" = htc."commandId" AND c."brandId" = htc."brandId") 
				and not exists (SELECT 1 from "HandoffEvents" he where c."id" = he."commandId" AND c."brandId" = he."brandId") 
            LIMIT batch_size
        ) AS subquery 
        WHERE subquery."id" = c."id" 
        AND subquery."brandId" = c."brandId";

        GET DIAGNOSTICS rows_deleted = ROW_COUNT;
        COMMIT;
        EXIT WHEN rows_deleted = 0;
    END LOOP;

    LOOP
        DELETE FROM "ClientCredentials" cc 
        USING (
            SELECT cc."id", cc."brandId" 
            FROM "ClientCredentials" cc 
            WHERE cc."expiresAt" < expiration_time 
            LIMIT batch_size
        ) AS subquery 
        WHERE subquery."id" = cc."id" 
        AND subquery."brandId" = cc."brandId";

        GET DIAGNOSTICS rows_deleted = ROW_COUNT;
        COMMIT;
        EXIT WHEN rows_deleted = 0;
    END LOOP;

    LOOP
        DELETE FROM "AccessTokens" at2 
        USING (
            SELECT at2."id", at2."brandId" 
            FROM "AccessTokens" at2 
            WHERE at2."expiresAt" < expiration_time 
            LIMIT batch_size
        ) AS subquery 
        WHERE subquery."id" = at2."id" 
        AND subquery."brandId" = at2."brandId";

        GET DIAGNOSTICS rows_deleted = ROW_COUNT;
        COMMIT;
        EXIT WHEN rows_deleted = 0;
    END LOOP;

    LOOP
        DELETE FROM "ReplayDetections" rd 
        USING (
            SELECT rd."id", rd."brandId" 
            FROM "ReplayDetections" rd 
            WHERE rd."expiresAt" < expiration_time 
            LIMIT batch_size
        ) AS subquery 
        WHERE subquery."id" = rd."id" 
        AND subquery."brandId" = rd."brandId";

        GET DIAGNOSTICS rows_deleted = ROW_COUNT;
        COMMIT;
        EXIT WHEN rows_deleted = 0;
    END LOOP;

END;
$$;