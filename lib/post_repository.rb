require_relative 'post'

class PostRepository
  def all
    sql = 'SELECT posts.id, 
                  posts.message, 
                  posts.timestamp,
                  users.id AS user_id, 
                  users.name, 
                  users.user_name 
          FROM posts 
          JOIN users ON posts.user_id = users.id;'
    results_set = DatabaseConnection.exec_params(sql, [])
    all_posts = results_set.map { |record| convert_to_post(record) }
    return all_posts
  end

  def find_by_user_id(user_id)
    sql = 'SELECT posts.id, 
                  posts.message, 
                  posts.timestamp, 
                  users.id AS user_id, 
                  users.name, 
                  users.user_name
          FROM posts
          JOIN users ON posts.user_id = users.id 
          WHERE user_id = $1;'
    params = [user_id]
    results_set = DatabaseConnection.exec_params(sql, params)
    users_posts = results_set.map { |record| convert_to_post(record) }
    return users_posts
  end

  def create(post)
    sql = 'INSERT INTO posts (message, timestamp, user_id) VALUES ($1, $2, $3);'
    params = [post.message, post.timestamp, post.user_id]
    DatabaseConnection.exec_params(sql, params)
    return nil
  end

  private

  def convert_to_post(record)
    post = Post.new
    post.id = record['id'].to_i
    post.message = record['message']
    post.timestamp = record['timestamp']
    post.user_id = record['user_id'].to_i
    post.name = record['name']
    post.user_name = record['user_name']
    return post
  end
end