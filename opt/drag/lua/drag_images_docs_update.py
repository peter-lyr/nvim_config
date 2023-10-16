import os
import re
import sys

markdown_fts = ["md"]

# 根据markdown文件相对路径进行更新

# M.get_relative_head = function(base_file, target_file)
#   local relative = string.sub(target_file, #base_file + 2, #target_file)
#   relative = vim.fn.fnamemodify(relative, ':h')
#   relative = string.gsub(relative, '(\\)', '/')
#   return string.gsub(relative, '([^/]+)', '..')
# end

#  def get_info(project, image_root_dir, image_root_md):
#      # 80cfb90646bc69aefa47b1d53eeafa4618c14a544105fe01f1aa3eaebaa1a35f![1238741982374619283461](80cfb906.jpg)
#      patt = r'([0-9a-f]{64})!\[([^\]]+)\]\((([0-9a-z]{8})\.(\w+))\)'
#      patt = re.compile(patt.encode('utf-8'))
#      image_root_dir = os.path.join(project, image_root_dir)
#      D = {}
#      with open(image_root_md, 'rb') as f:
#          lines = f.readlines()
#          for line in lines:
#              results = re.findall(patt, line)
#              if results:
#                  for result in results:
#                      name = result[2]
#                      hash_8 = result[3]
#                      if hash_8 not in D:
#                          D[hash_8] = rep(os.path.join(image_root_dir, name.decode('utf-8'))).encode('utf-8')
#      return D


def rep(text):
    return text.replace("\\", "/")


def do(file, image_root_dir, patt):
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
                    image_name = result[1]
                    hash_name = result[2].split(b"/")[-1]
                    # hash_8, ext = hash_name.split(b'.')[:]
                    relative = file[len(project) + 1 :]
                    if not printed:
                        print(f"-- {relative} --")
                    relative_dir = rep(os.path.dirname(relative))
                    relative_dir_dot = re.subn("[^/]+", "..", relative_dir)[0]
                    new = "%s%s](%s)" % (
                        head.decode('utf-8'),
                        image_name.decode("utf-8"),
                        rep(
                            os.path.join(
                                relative_dir_dot,
                                image_root_dir,
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


def update(project, image_root_dir, image_root_md, cur):
    # ![1238741982374619283461](../../../.images/80cfb906.jpg)
    patt = r"(.*\[)([^\]]+)\]\(([^\)]+)\)"
    patt = re.compile(patt.encode("utf-8"))
    if len(cur) > 0 and os.path.exists(cur):
        do(cur, image_root_dir, patt)
    else:
        for root, _, files in os.walk(project):
            for file in files:
                if file.split(".")[-1] in markdown_fts:
                    file = rep(os.path.join(root, file))
                    if file != image_root_md:
                        do(file, image_root_dir, patt)


if __name__ == "__main__":
    if len(sys.argv) != 5:
        os._exit(1)
    project, image_root_dir, image_root_md, cur = sys.argv[1:]
    image_root_md = rep(os.path.join(project, image_root_dir, image_root_md))

    #  D = get_info(project, image_root_dir, image_root_md)
    update(project, image_root_dir, image_root_md, cur)
