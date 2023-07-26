import os
import re
import sys

try:
    import matplotlib.pyplot as mp
    import numpy as np
    import mplcursors
except:
    os.system("pip install matplotlib numpy")
    os.system("pip install mplcursors")
    import mplcursors
    import matplotlib.pyplot as mp
    import numpy as np

class Analysis():
    def __init__(self, data_source, mode, data_tmp, *args, **kwargs):
        self.mode =mode.split('!')[0]
        self.plot_line = 0 if '!' in mode else 1
        self.data_source = data_source

        self.data_source_purified = data_tmp
        self.num_pattern = re.compile(r'^[\-|\+]?\d+(\.\d+)?$')
        self.hex_pattern = re.compile(r"^(0x[0-9a-fA-F]+|0X[0-9a-fA-F]+|[0-9a-fA-F]+)$")
        self.x_s = [] 
        self.y_s = []
        self.disp_last = False
        self.disp_first = False
        self.disp_line = []

    def is_num(self, i):
        return i and self.num_pattern.match(i)

    def is_hex(self, i):
        return i and self.hex_pattern.match(i)

    def purify_y(self, y):
        with open(self.data_source_purified, 'w') as f:
            word_len = max([len(str(i).strip()) for i in y])
            j = 0
            fmt = f'%{word_len+2}s'
            for i in range(len(y)):
                f.write(fmt % (y[i]))
                j += 1
                if j >= 20:
                    j = 0
                    f.write('\n')
                else:
                    f.write('')

    def append_axes(self, y, select, times):
        for j in select:
            self.y_s.append(np.array([y[i] for i in range(len(y)) if i % times == j]))
            self.x_s.append(np.arange(len(self.y_s[-1])))

    def get_xy(self):
        with open(self.data_source, 'rb') as f:
            lines = [line.decode('utf-8').strip() for line in f.readlines() if line.decode('utf-8').strip()]
        if 'y' == self.mode:
            self.mode = 'y_1'
        if 'Y' == self.mode:
            self.mode = 'Y_1'
        if 'y_' in self.mode or 'Y_' in self.mode:
            if 'y_' in self.mode:
                head = 'y_'
                y = [float(i) for i in re.subn(r'\s+', ' ', ' '.join(lines))[0].split(' ') if self.is_num(i)]
            else:
                head = 'Y_'
                y = [int(i, 16) for i in re.subn(r'\s+', ' ', ' '.join(lines))[0].split(' ') if self.is_hex(i)]
            if not y:
                os._exit(-1)
            qry = self.mode.split(head)[-1]
            tmp = qry.split('_')[0]
            times = eval(tmp) if tmp else 1
            try:
                idx = qry.split('_')[1]
                if not idx:
                    self.append_axes(y, list(range(times)), times)
                else:
                    select = sorted(list([eval(j) for j in idx]))
                    self.append_axes(y, select, times)
                try:
                    do = qry.split('_')[2].split(',')
                    if 's' in do and len(self.y_s[1]) == len(self.y_s[0]):
                        self.y_s.append(self.y_s[0] - self.y_s[1])
                        self.x_s.append(np.arange(len(self.y_s[0])))
                    if 'l' in do:
                        self.disp_last = True
                    if 'f' in do:
                        self.disp_first = True
                    self._disp_line(do)
                except:
                    pass
            except:
                self.append_axes(y, list(range(times)), times)
            self.purify_y(y)
        elif (self.mode == 'xy' or self.mode == 'xY') and len(lines) % 2 == 0:
            for j in range(0, len(lines), 2):
                if self.mode == 'xy':
                    self.x_s.append(np.array([float(i) for i in lines[j].split(' ') if self.is_num(i)]))
                    self.y_s.append(np.array([float(i) for i in lines[j+1].split(' ') if self.is_num(i)]))
                else:
                    self.x_s.append(np.array([int(i, 16) for i in lines[j].split(' ') if self.is_hex(i)]))
                    self.y_s.append(np.array([int(i, 16) for i in lines[j+1].split(' ') if self.is_hex(i)]))
        elif self.mode == 'C' or self.mode == 'c':
            if 'c' in self.mode:
                data = [float(i) for i in re.subn(r'\s+', ' ', ' '.join(lines))[0].split(' ') if self.is_num(i)]
            else:
                data = [int(i, 16) for i in re.subn(r'\s+', ' ', ' '.join(lines))[0].split(' ') if self.is_hex(i)]
            dict_data = {}
            for d in data:
                if d not in dict_data:
                    dict_data[d] = 1
                else:
                    dict_data[d] += 1
            data = sorted(list(zip(dict_data.keys(), dict_data.values())), key=lambda x: x[0])
            [print(d) for d in data]
            self.x_s.append(np.array([d[0] for d in data]))
            self.y_s.append(np.array([d[1] for d in data]))
        else:
            print("else")
            self.x_s.append([1, 2, 2, 1])
            self.y_s.append([1, 1, 2, 2])

    def _display_lines(self, x, y):
        for line in self.disp_line:
            if line == 'ey':
                mp.hlines(np.mean(y), min(x), max(x), linestyle=':', label=f'y_mean: {np.mean(y)}')
            if line == 'ay':
                mp.hlines(np.max(y), min(x), max(x), linestyle='--', label=f'y_max: {np.max(y)}')
            if line == 'iy':
                mp.hlines(np.min(y), min(x), max(x), linestyle='-.', label=f'y_min: {np.min(y)}')
            if line == 'ax':
                mp.vlines(np.max(x), min(y), max(y), linestyle='--', label=f'x_max: {np.max(x)}')
            if line == 'ix':
                mp.vlines(np.min(x), min(y), max(y), linestyle='-.', label=f'x_min: {np.min(x)}')

    def _disp_line(self, do):
        if 'y' in do:
            self.disp_line.append('ey')
            self.disp_line.append('ay')
            self.disp_line.append('iy')
        else:
            if 'ey' in do:
                self.disp_line.append('ey')
            if 'ay' in do:
                self.disp_line.append('ay')
            if 'iy' in do:
                self.disp_line.append('iy')
        if 'x' in do:
            self.disp_line.append('ix')
            self.disp_line.append('ax')
        else:
            if 'ix' in do:
                self.disp_line.append('ix')
            if 'ax' in do:
                self.disp_line.append('ax')

    def display_xy(self):
        self.get_xy()

        fig, ax = mp.subplots()
        ax.grid(linestyle=':')
        # mp.grid(linestyle=':')

        self.cmap = mp.get_cmap("tab10")
        for i in range(len(self.y_s)):
            color = self.cmap(i)

            if self.plot_line:
                mp.plot(self.x_s[i], self.y_s[i], linestyle='--', color=color, alpha=1, label=f'y_{i}')


            # mp.scatter(self.x_s[i], self.y_s[i], marker='o', s=40, alpha=1, cmap=color, label=f'y_{i}')

            # if i == 4:
                # mp.scatter(self.x_s[i], self.y_s[i], marker='o', s=160, alpha=1, cmap=color, label=f'y_{i}')
            # else:
                # mp.scatter(self.x_s[i], self.y_s[i], marker='o', s=40, alpha=1, cmap=color, label=f'y_{i}')

            ax.scatter(self.x_s[i], self.y_s[i], marker='o', s=40, alpha=1, cmap=color, label=f'y_{i}')
            crs = mplcursors.cursor(ax, hover=True)


            if self.disp_line:
                self._display_lines(self.x_s[i], self.y_s[i])
            if self.disp_last:
                mp.scatter([self.x_s[i][-1]], [self.y_s[i][-1]], marker="o",
                           s=80, cmap=color, zorder=3, label=f'y_{i} last: ({self.x_s[i][-1]}, {self.y_s[i][-1]})')
            if self.disp_first:
                mp.scatter([self.x_s[i][0]], [self.y_s[i][0]], marker="o",
                           s=80, cmap=color, zorder=3, label=f'y_{i} last: ({self.x_s[i][-1]}, {self.y_s[i][-1]})')

        mp.legend()
        mp.tight_layout()
        mp.get_current_fig_manager().window.state('zoomed')
        mp.show()


def main(data_source, mode, data_tmp):
    a = Analysis(data_source, mode, data_tmp)
    a.display_xy()


if __name__ == '__main__':
    # mode = 'xy'               # 偶数行，对应两行元素个数相同，对应第一行为横坐标，第二行为纵坐标，[行数/2]条折线
    # mode = 'y'                # 一条折线
    # mode = 'y_3_20'           # y_x[_y](x为大于等于2的数，y为显示选择)，x条折线
    # mode = 'y_6_01_sub'
    # mode = 'y_2__mean,last'
    # mode = 'y_2__mean'
    # mode = 'y_3_0_mean'
    # mode = 'y_3_01!' # 不连线
    # ey: mean_y
    # iy: min_y
    # ay: max_y
    # ex: mean_x
    # ix: min_x
    # ax: max_x
    # l:  last
    # f:  first
    # s:  sub
    if len(sys.argv) != 4:
        sys.exit(-1)

    main(sys.argv[1], sys.argv[2], sys.argv[3])
