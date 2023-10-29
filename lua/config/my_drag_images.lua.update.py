import os
import re
import sys

markdown_fts = ["md"]

# 根据markdown文件相对路径进行更新


def rep(text):
    return text.replace("\\", "/")


def do(file, patt):
    lines_new = []
    printed = 0
    with open(file, "rb") as f:
        lines = f.readlines()
        for line in lines:
            results = re.findall(patt, line)
            if results:
                temp = ""
                for result in results:
                    head = result[0]
                    image_doc_name = result[1]
                    image_doc_root_dir = result[2].split(b"/")[-2]
                    hash_name = result[2].split(b"/")[-1]
                    # hash_8, ext = hash_name.split(b'.')[:]
                    relative = file[len(project) + 1 :]
                    if not printed:
                        print(f"-- {relative} --")
                    relative_dir = rep(os.path.dirname(relative))
                    relative_dir_dot = re.subn("[^/]+", "..", relative_dir)[0]
                    new = "%s%s](%s)" % (
                        head.decode("utf-8"),
                        image_doc_name.decode("utf-8"),
                        rep(
                            os.path.join(
                                relative_dir_dot,
                                image_doc_root_dir.decode("utf-8"),
                                hash_name.decode("utf-8"),
                            )
                        ),
                    )
                    printed += 1
                    print(str(printed) + ".", new)
                    temp += new
                lines_new.append(temp.encode("utf-8") + b"\n")
            else:
                lines_new.append(line)
    if printed:
        print("\n")
    with open(file, "wb") as f:
        f.writelines(lines_new)


def update(project, image_doc_root_md, cur):
    # ![1238741982374619283461](../../../.images/80cfb906.jpg)
    patt = r"(.*\[)([^\]]+)\]\(([^\)]+)\)"
    patt = re.compile(patt.encode("utf-8"))
    if len(cur) > 0 and os.path.exists(cur):
        do(cur, patt)
    else:
        for root, _, files in os.walk(project):
            for file in files:
                if file.split(".")[-1] in markdown_fts:
                    file = rep(os.path.join(root, file))
                    if file != image_doc_root_md:
                        do(file, patt)


if __name__ == "__main__":
    if len(sys.argv) != 4:
        os._exit(1)
    project, image_doc_root_md, cur = sys.argv[1:]
    image_doc_root_md = rep(os.path.join(project, image_doc_root_md))

    update(project, image_doc_root_md, cur)
