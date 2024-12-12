import argparse

def modify_file_content(input_file, output_file, string_to_replace, replacement):
    """
    Reads the input file, replaces occurrences of a string, and writes it to the output file.

    :param input_file: str, path to the input file
    :param output_file: str, path to the output file
    :param string_to_replace: str, the string to replace in the content
    :param replacement: str, the string to replace it with
    """
    try:
        # Read the content of the input file
        with open(input_file, 'r') as file:
            content = file.read()

        # Replace the specified string
        modified_content = content.replace(string_to_replace, replacement)

        # Write the modified content to the output file
        with open(output_file, 'w') as file:
            file.write(modified_content)

        print(f"Modified file written to: {output_file}")

    except FileNotFoundError:
        print(f"Error: The file '{input_file}' was not found.")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Modify the content of a file by replacing a string and save it to an output file.")
    parser.add_argument("--input_file", type=str, help="Path to the input file.")
    parser.add_argument("--output_file", type=str, help="Path to the output file.")
    parser.add_argument("--string_to_replace", type=str, help="The string to replace in the input file.")
    parser.add_argument("--replacement", type=str, help="The string to replace it with.")

    args = parser.parse_args()

    # Modify the file content and write the new file
    modify_file_content(args.input_file, args.output_file, args.string_to_replace, args.replacement)

