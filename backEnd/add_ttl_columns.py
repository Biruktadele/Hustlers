#!/usr/bin/env python3
"""
Add TTL columns to JobPost table and set up PostgreSQL TTL functionality
"""

from sqlalchemy import text
from app.db.session import engine
import sys

def add_ttl_columns():
    """Add TTL columns and set up automatic cleanup"""
    
    try:
        with engine.connect() as conn:
            # Start transaction
            trans = conn.begin()
            
            print("Adding TTL columns to job_posts table...")
            
            # Check if table exists
            result = conn.execute(text("""
                SELECT table_name FROM information_schema.tables 
                WHERE table_schema = 'public' AND table_name = 'job_posts'
            """))
            
            if not result.fetchone():
                print("Table 'job_posts' doesn't exist. Creating new table...")
                from app.db.init_db import init_db
                init_db()
                print("New table created with TTL columns!")
                return
            
            # Check if ttl_hours column exists
            result = conn.execute(text("""
                SELECT column_name FROM information_schema.columns 
                WHERE table_name = 'job_posts' AND column_name = 'ttl_hours'
            """))
            
            if not result.fetchone():
                print("Adding ttl_hours column...")
                conn.execute(text("""
                    ALTER TABLE job_posts ADD COLUMN ttl_hours INTEGER
                """))
            
            # Check if expires_at column exists
            result = conn.execute(text("""
                SELECT column_name FROM information_schema.columns 
                WHERE table_name = 'job_posts' AND column_name = 'expires_at'
            """))
            
            if not result.fetchone():
                print("Adding expires_at column...")
                conn.execute(text("""
                    ALTER TABLE job_posts ADD COLUMN expires_at TIMESTAMP WITH TIME ZONE
                """))
            
            # Create index on expires_at for faster cleanup queries
            print("Creating index on expires_at...")
            conn.execute(text("""
                CREATE INDEX IF NOT EXISTS idx_job_posts_expires_at ON job_posts(expires_at)
            """))
            
            # Create a function for automatic cleanup (optional - can be called by cron)
            print("Creating cleanup function...")
            conn.execute(text("""
                CREATE OR REPLACE FUNCTION cleanup_expired_jobs()
                RETURNS INTEGER AS $$
                DECLARE
                    deleted_count INTEGER;
                BEGIN
                    DELETE FROM job_posts 
                    WHERE expires_at IS NOT NULL 
                    AND expires_at < NOW();
                    
                    GET DIAGNOSTICS deleted_count = ROW_COUNT;
                    RETURN deleted_count;
                END;
                $$ LANGUAGE plpgsql;
            """))
            
            # Commit transaction
            trans.commit()
            print("TTL columns added successfully!")
            print("Cleanup function 'cleanup_expired_jobs()' created for manual execution.")
            
    except Exception as e:
        print(f"Migration failed: {e}")
        sys.exit(1)

if __name__ == "__main__":
    add_ttl_columns()
