# Processes the strings it gets from the queue and builds the panel bar.
from subprocess import Popen, PIPE
from shlex import split

# These are unicode private use area codes, for use with Typicons font.
ICONS = {'date': '\ue038',
         'battery_charging': '\ue02a',
         'battery_full': '\ue02b',
         'battery_high': '\ue02c',
         'battery_mid': '\ue02e',
         'battery_low': '\ue02d',
         'keyboard': '\ue098',
         'mail': '\ue0a5'}


def color(mode, color, message='', reset=False):
    colors = {'red': '#fffb9fb1',
              'green': '#ffacc267',
              'yellow': '#ffddb26f',
              'blue': '#ff6fc2ef',
              'violet': '#ffe1a3ee',
              'cyan': '#ff12cfc0',
              'white': '#ffd0d0d0',
              'gray': '#ff151515',
              'reset': '-'
              }

    if mode == 'fg':
        result = '{}{}{}{}'.format('%{F', colors[color], '}', message)
        if reset:
            return '{}{}{}{}'.format(result, '%{F', colors['reset'], '}')
        else:
            return result

    elif mode == 'bg':
        result = '{}{}{}{}'.format('%{B', colors[color], '}', message)
        if reset:
            return '{}{}{}{}'.format(result, '%{B', colors['reset'], '}')
        else:
            return result


SEPARATOR = color('fg', 'blue', ' \u2502 ', reset=True)
CENTER = '%{c}'
RIGHT = '%{r}'

LAYOUT = ['W', SEPARATOR, CENTER, 'T',
          RIGHT, SEPARATOR, 'M', ICONS['keyboard'],
          'K', ' ', 'B', ' ', ICONS['date'], 'D']

MAIN_FONT = '-misc-dejavu sans-medium-r-normal--12-0-0-0-p-0-iso10646-1'
ALT_FONT = '-misc-typicons-medium-r-normal--12-80-100-100-p-60-iso10646-1'
BAR_FG = '-F #FFD0D0D0'
BAR_BG = '-B #80151515'
COMMAND = 'bar -p -f "{},{}" {} {}'.format(MAIN_FONT, ALT_FONT,
                                           BAR_BG, BAR_FG)


def parse_wm_status(contents):
    wm_info = contents.split(':')
    # Remove monitor label
    wm_info.pop(0)
    # Remove current tiling mode
    wm_info.pop(-1)

    desktops = []
    for d in wm_info:
        # Focused {urgent, occupied} desktops
        if d[0] == 'U' or d[0] == 'O' or d[0] == 'F':
            desktops.append(color('fg', 'blue', d[1], reset=True))

        # Unfocused urgent desktops
        elif d[0] == 'u':
            desktops.append(color('bg', 'red',
                                  color('bg', 'white',
                                        d[1], reset=True),
                                  reset=True))

        # Unfocused unoccupied desktops
        else:
            desktops.append(d[1])

    return ' '.join(desktops)


def parse_win_title(contents):
    if len(contents) > 72:
        output = '{}\u2026'.format(contents[:72])
    else:
        output = contents

    return output


def parse_mail_count(contents):
    if contents != '0':
        output = '{} '.format(ICONS['mail'])
    else:
        output = ''

    return output


def parse_battery(contents):
    charge = int(contents)
    if charge > 80:
        return ICONS['battery_full']
    elif charge > 60:
        return ICONS['battery_high']
    elif charge > 30:
        return ICONS['battery_mid']
    else:
        return ICONS['battery_low']


def parse_other(contents):
    return contents


def parse(status, item):
    """
    Substitute a part of the input list for a parsed version of the "item"

    [list] -> [list]
    """

    prefix, contents = item[0], item[1:]
    handler_for = {'W': parse_wm_status,
                   'M': parse_mail_count,
                   'T': parse_win_title,
                   'B': parse_battery,
                   'D': parse_other,
                   'K': parse_other}

    if prefix in handler_for:
        status[LAYOUT.index(prefix)] = handler_for[prefix](contents)

    return status


def main(queue):
    """ Start the main app loop """
    bar = Popen(split(COMMAND),
                stdin=PIPE,
                bufsize=-1,
                stdout=None,
                universal_newlines=True)
    status = list(LAYOUT)
    while True:
        item = queue.get()
        status = parse(status, item)
        #print(status)
        bar.stdin.write(''.join(status))
        bar.stdin.write('\n')
        bar.stdin.flush()
