import os
import re


def replace(match, saved_images_dirname):
    if match.lastindex != 3:
        return ""
    projectroot = saved_images_dirname.replace("\\", "/")
    file_dir = os.path.dirname(fname).replace("\\", "/")
    rel = file_dir.replace(projectroot, "")
    rel_path = re.sub(r"\s", "", match.group(3))
    rel_path = (
        "".join(["../" for _ in rel.strip("/").split("/")])
        + "saved_images/"
        + re.sub(r"[\.\/]+?saved_images/", "", rel_path, 1)
    )
    return "![{}{{{}}}]({})".format(
        re.sub(r"\s", "", match.group(1)), re.sub(r"\s", "", match.group(2)), rel_path
    )


def update_one_markdown_image_src(saved_images_dirname, fname):
    with open(fname, "rb") as f:
        content = f.read().decode("utf-8")
    patt = re.compile(r"!\[([\s\S]+?)\{([0-9a-fA-F\s]+?)\}\]\(([\s\S]+?)\)")
    content_new, _ = re.subn(
        patt, lambda match: replace(match, saved_images_dirname), content
    )
    with open(fname, "wb") as f:
        content = f.write(content_new.encode("utf-8"))


if __name__ == "__main__":
    import sys

    if len(sys.argv) != 3:
        print("len(sys.argv) != 3")
        sys.exit(0)

    saved_images_dirname = sys.argv[1]
    fname = sys.argv[2]

    update_one_markdown_image_src(saved_images_dirname, fname)
