import requests
import json

BASE_URL = "http://127.0.0.1:5000"
RESULTS_FILE = "results.txt"


def write_result(title, response):
    try:
        response_body = response.json()
    except Exception:
        response_body = response.text

    result = (
        f"\n{'=' * 60}\n"
        f"{title}\n"
        f"Status code: {response.status_code}\n"
        f"Response:\n"
        f"{json.dumps(response_body, indent=4, ensure_ascii=False)}\n"
    )

    print(result)

    with open(RESULTS_FILE, "a", encoding="utf-8") as file:
        file.write(result)


def clear_results_file():
    with open(RESULTS_FILE, "w", encoding="utf-8") as file:
        file.write("REST API test results\n")


def main():
    clear_results_file()

    # 1. Отримати всіх наявних студентів
    response = requests.get(f"{BASE_URL}/students")
    write_result("1. GET all students", response)

    # 2. Створити трьох студентів
    student_1 = {
        "first_name": "Ivan",
        "last_name": "Petrenko",
        "age": 20
    }

    student_2 = {
        "first_name": "Olena",
        "last_name": "Shevchenko",
        "age": 21
    }

    student_3 = {
        "first_name": "Andrii",
        "last_name": "Koval",
        "age": 22
    }

    response = requests.post(f"{BASE_URL}/students", json=student_1)
    write_result("2.1 POST create first student", response)
    first_student = response.json()

    response = requests.post(f"{BASE_URL}/students", json=student_2)
    write_result("2.2 POST create second student", response)
    second_student = response.json()

    response = requests.post(f"{BASE_URL}/students", json=student_3)
    write_result("2.3 POST create third student", response)
    third_student = response.json()

    first_student_id = first_student["id"]
    second_student_id = second_student["id"]
    third_student_id = third_student["id"]

    # 3. Отримати інформацію про всіх наявних студентів
    response = requests.get(f"{BASE_URL}/students")
    write_result("3. GET all students after POST", response)

    # 4. Оновити вік другого студента
    response = requests.patch(
        f"{BASE_URL}/students/{second_student_id}",
        json={"age": 25}
    )
    write_result("4. PATCH update age of second student", response)

    # 5. Отримати інформацію про другого студента
    response = requests.get(f"{BASE_URL}/students/{second_student_id}")
    write_result("5. GET second student by ID", response)

    # 6. Оновити імʼя, прізвище та вік третього студента
    updated_third_student = {
        "first_name": "Mykola",
        "last_name": "Bondarenko",
        "age": 23
    }

    response = requests.put(
        f"{BASE_URL}/students/{third_student_id}",
        json=updated_third_student
    )
    write_result("6. PUT update third student", response)

    # 7. Отримати інформацію про третього студента
    response = requests.get(f"{BASE_URL}/students/{third_student_id}")
    write_result("7. GET third student by ID", response)

    # Додаткова перевірка GET за прізвищем
    response = requests.get(f"{BASE_URL}/students/lastname/Bondarenko")
    write_result("7.1 GET students by last name", response)

    # 8. Отримати всіх наявних студентів
    response = requests.get(f"{BASE_URL}/students")
    write_result("8. GET all students before DELETE", response)

    # 9. Видалити першого користувача
    response = requests.delete(f"{BASE_URL}/students/{first_student_id}")
    write_result("9. DELETE first student", response)

    # 10. Отримати всіх наявних студентів
    response = requests.get(f"{BASE_URL}/students")
    write_result("10. GET all students after DELETE", response)


if __name__ == "__main__":
    main()