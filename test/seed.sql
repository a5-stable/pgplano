-- Users table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tasks table
CREATE TABLE IF NOT EXISTS tasks (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(20) DEFAULT 'pending',
    due_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sample users
INSERT INTO users (name, email) VALUES
    ('John Smith', 'john@example.com'),
    ('Emily Johnson', 'emily@example.com'),
    ('Michael Brown', 'michael@example.com');

-- Sample tasks
INSERT INTO tasks (user_id, title, description, status, due_date) VALUES
    (1, 'Create project proposal', 'Draft the proposal for the new project', 'in_progress', '2026-02-20'),
    (1, 'Prepare for meeting', 'Prepare materials for the weekly meeting', 'pending', '2026-02-15'),
    (2, 'Code review', 'Review the pull request', 'completed', '2026-02-13'),
    (2, 'Run tests', 'Execute integration tests and report', 'pending', '2026-02-18'),
    (3, 'Update documentation', 'Update the API specification', 'in_progress', '2026-02-17');
