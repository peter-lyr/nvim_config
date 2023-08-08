import os
import sys

def rep(text):
    return text.replace('\\', '/').lower()

def get_executable_cbp(project_root):
    cbp_files = []
    for root, _, files in os.walk(project_root):
        for file in files:
            if file.endswith(".cbp"):
                cbp_files.append(rep(os.path.join(root, file)))
    executable_cbp = ''
    if len(cbp_files) == 1:
        executable_cbp = cbp_files[0]
    elif len(cbp_files) > 1:
        for cbp_file in cbp_files:
            if os.path.basename(cbp_file) in ['pp.cbp']:
                executable_cbp = cbp_file
                break
        else:
            res = input('Type number to choose one of cbp as executable\n' + 
                  '\n'.join([str(i+1) + '. ' + v for i, v in enumerate(cbp_files)]) + '\n'
                  '>> ')
            try:
                num = int(res)
                if num in [i + 1 for i, _ in enumerate(cbp_files)]:
                    executable_cbp = cbp_files[num - 1]
            except Exception as e:
                print(e)
    print(executable_cbp)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        os._exit(1)

    project_root = rep(sys.argv[1])

    executable_cbp = get_executable_cbp(project_root)
    print(executable_cbp)
