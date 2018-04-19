module TodoDB

    DB_PATH = './database/database.sqlite'

    def db_connect()
        db = SQLite3::Database.new(DB_PATH)
        db.results_as_hash = true
        return db
    end
        
    def user_compare(username)
        db = db_connect()
        result = db.execute("SELECT * FROM users WHERE username = ?",[username])
        return result
    end

    def create_user(username, crypt_pass, nickname)
        if nickname == nil
            nickname = "This user has not set a nickname yet"
        end

        db = db_connect()
        request = db.execute("INSERT INTO users('username', 'password', 'nickname') VALUES(?,?,?)", [username, crypt_pass, nickname])
        return request
    end




end
