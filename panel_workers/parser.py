# Processes the strings it gets from the queue and builds the panel bar.
from subprocess import Popen, PIPE

SEPARATOR = '  '
CENTER = '\c'
RIGHT = '\\r'

# These are unicode private use area codes, for use with Typicons font.
ICONS = {'date': '\ue038',
         'battery_charging': '\ue02a',
         'battery_full': '\ue02b',
         'battery_high': '\ue02c',
         'battery_mid': '\ue02e',
         'battery_low': '\ue02d',
         'keyboard': '\ue098',
         'mail': '\ue0a5'}

COLORS_FG = {'red': '\\f1',
             'green': '\\f2',
             'orange': '\\f3',
             'blue': '\\f4',
             'violet': '\\f5',
             'cyan': '\\f6',
             'white': '\\f7',
             'gray': '\\f8',
             'brown': '\\f9',
             'reset': '\\fr'
             }

COLORS_BG = {'red': '\\b1',
             'green': '\\b2',
             'orange': '\\b3',
             'blue': '\\b4',
             'violet': '\\b5',
             'cyan': '\\b6',
             'white': '\\b7',
             'gray': '\\b8',
             'brown': '\\b9',
             'reset': '\\br'
             }

LAYOUT = ['W', CENTER, 'T', RIGHT, 'M', ICONS['keyboard'],
          'K', SEPARATOR, 'B', SEPARATOR, ICONS['date'], 'D']


def parse_wm_status(line):
    wm_info = line[1:].split(':')
    # Remove monitor label
    wm_info.pop(0)
    # Remove current tiling mode
    wm_info.pop(-1)

    desktops = []
    for d in wm_info:
        # Focused {urgent, occupied} desktops
        if d[0] == 'U' or d[0] == 'O' or d[0] == 'F':
            desktops.append('{}{}{}'.format(COLORS_FG['blue'],
                                            d[1],
                                            COLORS_FG['reset']))

        # Unfocused urgent desktops
        elif d[0] == 'u':
            desktops.append('{}{}{}{}{}'.format(COLORS_BG['red'],
                                                COLORS_FG['white'],
                                                d[1],
                                                COLORS_FG['reset'],
                                                COLORS_BG['reset']))

        # Unfocused unoccupied desktops
        else:
            desktops.append(d[1])

    return ' '.join(desktops)


def parse_win_title(line):
    if len(line) > 69:
        output = '{0}...'.format(line[1:69])
    else:
        output = line[1:]

    return output


def parse_mail_count(line):
    if line[1:] != '0':
        output = '{} {}'.format(ICONS['mail'], SEPARATOR)
    else:
        output = ''

    return output


def parse_battery(line):
    charge = int(line[1:])
    if charge > 80:
        return ICONS['battery_full']
    elif charge > 60:
        return ICONS['battery_high']
    elif charge > 30:
        return ICONS['battery_mid']
    else:
        return ICONS['battery_low']


def parse_other(line):
    return line[1:]


def parse(status, line):
    """
    Substitute a part of the "status" list for a parsed version of "line"

    [list], str -> str
    """

    prefix = line[0]

    handler_for = {'W': parse_wm_status,
                   'M': parse_mail_count,
                   'T': parse_win_title,
                   'B': parse_battery,
                   'D': parse_other,
                   'K': parse_other}

    status[LAYOUT.index(prefix)] = handler_for[prefix](line)

    return ' '.join(status)


def main(queue):
    """ Start the main app loop """
    bar = Popen(['bar', '-p'], stdin=PIPE,
                universal_newlines=True)
    current_status = list(LAYOUT)
    while True:
        item = queue.get()
        output = parse(current_status, item)
        bar.stdin.write(output + '\n')