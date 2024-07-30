import os
import re

def parse_prolog_file(file_path):
    with open(file_path, 'r') as file:
        content = file.read()

    arity_1_predicates = {}
    arity_2_predicates = []
    
    # Parse arity 1 predicates
    for match in re.finditer(r'(\w+)\((\w+)\)\.', content):
        predicate, parameter = match.groups()
        if predicate not in arity_1_predicates:
            arity_1_predicates[predicate] = set()
        arity_1_predicates[predicate].add(parameter)

    # Parse arity 2 predicates
    for match in re.finditer(r'(\w+)\((\w+),\s*(\w+)\)\.', content):
        predicate, param1, param2 = match.groups()
        arity_2_predicates.append((predicate, param1, param2))

    return arity_1_predicates, arity_2_predicates
def create_folders_and_files(arity_1_predicates, arity_2_predicates, output_dir):
    os.makedirs(output_dir, exist_ok=True)

    # Create folders and files for arity 1 predicates
    for predicate, parameters in arity_1_predicates.items():
        predicate_dir = os.path.join(output_dir, predicate)
        os.makedirs(predicate_dir, exist_ok=True)
        pred_file_path = os.path.join(predicate_dir, f"{predicate}.md")
        with open(pred_file_path, 'a') as file:
            file.write("%% Waypoint ")
            file.write("%% \n")

        for parameter in parameters:
            file_path = os.path.join(predicate_dir, f"{parameter}.md")
            with open(file_path, 'w') as file:
                file.write(f"# {parameter}\n\n")

    # Add arity 2 predicates as links
    for predicate, param1, param2 in arity_2_predicates:
        # Find which arity 1 predicate contains param1
        for arity_1_pred, params in arity_1_predicates.items():
            if param1 in params:
                param_file_path = os.path.join(output_dir, arity_1_pred, f"{param1}.md")
                with open(param_file_path, 'a') as file:
                    file.write(f"{predicate}::[[{param2}]]\n")
                break
        else:
            uncategorized_dir = os.path.join(output_dir, "uncategorized")
            print(f"Warning: No matching arity 1 predicate found for {param1} in {predicate}({param1}, {param2}). Saving in {uncategorized_dir}")
            os.makedirs(uncategorized_dir, exist_ok=True)
            param_file_path = os.path.join(uncategorized_dir, f"{param1}.md")
            with open(param_file_path, 'a') as file:
                file.write(f"{predicate}::[[{param2}]]\n")

    print("Folders and files created successfully!")

def main():
    input_file = "./test.pl"  # Change this to your Prolog file name
    output_dir = "output"    # Change this to your desired output directory

    arity_1_predicates, arity_2_predicates = parse_prolog_file(input_file)
    create_folders_and_files(arity_1_predicates, arity_2_predicates, output_dir)

    print("Folders and files created successfully!")

if __name__ == "__main__":
    main()
