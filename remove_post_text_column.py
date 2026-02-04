#!/usr/bin/env python3
"""
Remove post_text column from JobPost table
"""

from sqlalchemy import text
from app.db.session import engine
import sys

def remove_post_text_column():
    """Remove post_text column from job_posts table"""
    
    try:
        with engine.connect() as conn:
            # Start transaction
            trans = conn.begin()
            
            print("Removing post_text column from job_posts table...")
            
            # Check if table exists
            result = conn.execute(text("""
                SELECT table_name FROM information_schema.tables 
                WHERE table_schema = 'public' AND table_name = 'job_posts'
            """))
            
            if not result.fetchone():
                print("Table 'job_posts' doesn't exist.")
                return
            
            # Check if post_text column exists
            result = conn.execute(text("""
                SELECT column_name FROM information_schema.columns 
                WHERE table_name = 'job_posts' AND column_name = 'post_text'
            """))
            
            if result.fetchone():
                print("Dropping post_text column...")
                conn.execute(text("""
                    ALTER TABLE job_posts DROP COLUMN post_text
                """))
                print("post_text column removed successfully!")
            else:
                print("post_text column doesn't exist.")
            
            # Update cleanup function to not reference post_text
            print("Updating cleanup function...")
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
            print("Migration completed successfully!")
            
    except Exception as e:
        print(f"Migration failed: {e}")
        sys.exit(1)

if __name__ == "__main__":
    remove_post_text_column()
