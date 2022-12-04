# This migration was auto-generated via `rake db:generate_trigger_migration'.
# While you can edit this file, any changes you make to the definitions here
# will be undone by the next auto-generated trigger migration.

class CreateTriggerBotOutsInsert < ActiveRecord::Migration[7.0]

  execute <<-SQL
        CREATE OR REPLACE FUNCTION fix_bot_outs()
        RETURNS TRIGGER
        LANGUAGE plpgsql
        AS
        $$
        BEGIN
          IF NEW.time > 5 THEN
            DELETE FROM bot_outs 
            WHERE time = NEW.time - 5 AND bot_id = NEW.bot_id;
          END IF;
          RETURN NULL;
        END;
        $$;
        
        CREATE TRIGGER fix_bot_outs
        AFTER INSERT ON bot_outs
        FOR EACH ROW
        EXECUTE PROCEDURE fix_bot_outs();
  SQL

end
