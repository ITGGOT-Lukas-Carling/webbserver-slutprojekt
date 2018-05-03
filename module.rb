module TodoDB

    DB_PATH = './database/database.sqlite'

    def db_connect()
        db = SQLite3::Database.new(DB_PATH)
        #db.results_as_hash = true
        return db
    end
        
    def user_compare(username)
        db = db_connect()
        result = db.execute("SELECT * FROM users WHERE username IS ?", [username])
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

    def find_password_for_user(username)
        db = db_connect()
        password = db.execute("SELECT password FROM users WHERE username IS ?", [username])
        return password
    end

    def user_id(username)
        db = db_connect()
        user_id = db.execute("SELECT id FROM users WHERE username is ?", [username])
        return user_id[0]
    end

    def add_friend(user_1, user_2)
        db = db_connect()
        db.execute("INSERT INTO user_relations(user_1, user_2, relation_state) VALUES (?,?,1)", [user_1, user_2])
    end

    def user_relation(user_1, user_2) 
        db = db_connect()
        result = db.execute("SELECT relation_state FROM user_relations WHERE (user_1 = ? OR user_2 = ?) AND (user_1 = ? OR user_2 = ?)", [user_1, user_1, user_2, user_2])
        print result
        if result.empty? == false
            if result[0][0]==1
                return "This user is your friend"
            end
        else
            return "This user is not your friend"
        end
        
        
    end

end
