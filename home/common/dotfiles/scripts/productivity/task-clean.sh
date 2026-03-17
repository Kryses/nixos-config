#!/home/kryses/.venv/bin/python


def check_and_fix_utf8(file_path):
    with open(file_path, "r", encoding="utf-8", errors="replace") as file:
        content = file.read()

    # Check for problematic characters
    invalid_characters = [char for char in content if ord(char) > 127]

    if invalid_characters:
        # Replace problematic characters
        fixed_content = "".join(char if ord(char) <= 127 else "?" for char in content)

        # Write fixed content back to the file
        with open(file_path, "w", encoding="utf-8") as file:
            file.write(fixed_content)

        print("Problematic characters replaced.")
    else:
        print("File is already in UTF-8 and does not contain problematic characters.")


# Replace 'your_file.txt' with your file path
check_and_fix_utf8("/home/kryses/.task/pending.data")
