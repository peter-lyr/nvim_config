import os
import subprocess
import sys


def get_only_name(file):
  d1 = file.split("/")
  if d1:
    d2 = d1[-1]
    d2 = d2.split("\\")
    if d2:
      return d2[-1]
    else:
      return d1[-1]
  else:
    return file


def rep(text):
  return text.replace("\\", "/").lower().rstrip("/")


if __name__ == "__main__":
  if len(sys.argv) < 6:
    os._exit(1)

  cur_repo = rep(sys.argv[1])
  dir = rep(sys.argv[2])
  cur_branchname = rep(sys.argv[3])
  repo = rep(sys.argv[4])
  branchname = rep(sys.argv[5])
  do_not_move_itmes = sys.argv[6:]

  # print('cur_repo:', cur_repo)
  # print('dir:', dir)
  # print('cur_branchname:', cur_branchname)
  # print('repo:', repo)
  # print(get_only_name(repo))

  # res = os.popen('git ls-files -t').read()
  # for line in res.splitlines():
  #   print(line)

  cmd = []
  cmd.append(f"cd {cur_repo}")
  cmd.append(f"git remote add __{get_only_name(repo)} {repo}")
  cmd.append(f"git fetch __{get_only_name(repo)}")
  cmd.append(
    f"git checkout -b __{get_only_name(repo)}_b __{get_only_name(repo)}/{branchname}"
  )
  os.system(" & ".join(cmd))

  files = []
  process = subprocess.Popen("git ls-files -c", stdout=subprocess.PIPE, shell=True)
  for line in process.communicate()[0].decode("utf-8").split("\n"):
    files.append(line)

  cmd = []
  cmd.append(f"git checkout {cur_branchname}")
  cmd.append(f"git merge __{get_only_name(repo)}_b --allow-unrelated-histories")
  os.system(" & ".join(cmd))

  process = subprocess.Popen(
    "git ls-files -u --format=%(path)", stdout=subprocess.PIPE, shell=True
  )
  for line in process.communicate()[0].decode("utf-8").split("\n"):
    if line in files:
      files.remove(line)
  for item in do_not_move_itmes:
    if item in files:
      files.remove(item)

  cmd = []
  cmd.append("git checkout --ours *")
  cmd.append("git add -- .")
  cmd.append("git merge --continue")
  os.system(" & ".join(cmd))

  cmd2 = []
  if dir:
    dir = os.path.join(cur_repo, dir).replace("\\", "/")
    os.makedirs(dir, exist_ok=True)
    dirs = []
    for file in files:
      d = file.split("/")[0]
      if d not in dirs:
        dirs.append(d)
        os.system(f'git mv "{d}" "{dir}/{d}"')
    os.system(f"git add .")
    os.system(f'git commit -m "move to {get_only_name(repo)}"')
    os.system(f"git push")
  os.system("pause")
