from flask import Flask, jsonify, request, send_from_directory

app = Flask(__name__, static_folder="static")


@app.route("/", methods=["GET"])
def index():
    """Serve the React frontend"""
    return send_from_directory(app.static_folder, "index.html")


# In-memory storage (simple for now — later you can connect a real DB)
tasks = []
next_id = 1


@app.route("/health", methods=["GET"])
def health():
    """Health check endpoint - used by load balancers to check if the app is alive"""
    return jsonify({"status": "ok"}), 200


@app.route("/tasks", methods=["GET"])
def get_tasks():
    """Return all tasks"""
    return jsonify(tasks), 200


@app.route("/tasks", methods=["POST"])
def create_task():
    """Add a new task. Expects JSON body: {"title": "Buy milk"}"""
    global next_id
    data = request.get_json()

    if not data or "title" not in data:
        return jsonify({"error": "title is required"}), 400

    task = {
        "id": next_id,
        "title": data["title"],
        "done": False
    }
    tasks.append(task)
    next_id += 1

    return jsonify(task), 201


@app.route("/tasks/<int:task_id>", methods=["DELETE"])
def delete_task(task_id):
    """Delete a task by id"""
    global tasks
    original_len = len(tasks)
    tasks = [t for t in tasks if t["id"] != task_id]

    if len(tasks) == original_len:
        return jsonify({"error": "task not found"}), 404

    return jsonify({"message": "task deleted"}), 200


if __name__ == "__main__":
    # 0.0.0.0 so it's reachable from outside the container later
    app.run(host="0.0.0.0", port=5000, debug=True)
