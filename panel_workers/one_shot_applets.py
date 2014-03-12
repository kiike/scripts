# Executes the processes in the list just once, outputting stdout into the
# queue.
from subprocess import check_output

one_shot_applets = ['kbdlayout get']


def main(queue):
    for app in one_shot_applets:
        output = check_output(app.split(),
                              shell=False,
                              stdin=None,
                              universal_newlines=True)
        if len(output) > 0:
            output = output.strip()
            queue.put(output)
