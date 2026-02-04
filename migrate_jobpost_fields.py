#!/usr/bin/env python3
"""
Migration script to update JobPost table field names to match AI service output
"""

from sqlalchemy import text
from app.db.session import engine
import sys

def migrate_jobpost_fields():
    """Update JobPost table field names"""
    
    # Field mappings: old_name -> new_name
    field_mappings = {
        'job_name': 'jobname',
        'job_type': 'jobtype', 
        'salary': 'price',
        'application_deadline': 'expierdate',
        'job_description': 'jobdescrbiton'
    }
    
    try:
        with engine.connect() as conn:
            # Start transaction
            trans = conn.begin()
            
            print("Starting JobPost field migration...")
            
            # Check if table exists
            result = conn.execute(text("""
                SELECT table_name FROM information_schema.tables 
                WHERE table_schema = 'public' AND table_name = 'job_posts'
            """))
            
            if not result.fetchone():
                print("Table 'job_posts' doesn't exist. Creating new table...")
                # Just create the new table structure
                from app.db.init_db import init_db
                init_db()
                print("New table created with updated field names!")
                return
            
            # For each field, rename if it exists
            for old_name, new_name in field_mappings.items():
                try:
                    # Check if old column exists
                    result = conn.execute(text(f"""
                        SELECT column_name FROM information_schema.columns 
                        WHERE table_name = 'job_posts' AND column_name = '{old_name}'
                    """))
                    
                    if result.fetchone():
                        print(f"Renaming {old_name} -> {new_name}")
                        
                        # PostgreSQL supports ALTER TABLE RENAME COLUMN
                        conn.execute(text(f"""
                            ALTER TABLE job_posts RENAME COLUMN {old_name} TO {new_name}
                        """))
                        
                        print(f"Successfully renamed {old_name} -> {new_name}")
                    
                except Exception as e:
                    print(f"Error renaming {old_name}: {e}")
                    # Continue with other fields
            
            # Remove job_location field if it exists
            result = conn.execute(text("""
                SELECT column_name FROM information_schema.columns 
                WHERE table_name = 'job_posts' AND column_name = 'job_location'
            """))
            
            if result.fetchone():
                print("Removing job_location field...")
                conn.execute(text("""
                    ALTER TABLE job_posts DROP COLUMN job_location
                """))
                print("Successfully removed job_location field")
            
            # Commit transaction
            trans.commit()
            print("Migration completed successfully!")
            
    except Exception as e:
        print(f"Migration failed: {e}")
        sys.exit(1)

if __name__ == "__main__":
    migrate_jobpost_fields()
