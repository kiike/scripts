#!/usr/bin/env python
# Download airport charts for Spain

import bs4
import os
import subprocess
import time
import urllib.request

BASE_URL = "http://www.enaire.es"


def expand(url):
    try:
        request = urllib.request.urlopen(BASE_URL + url)
    except urllib.error.URLError:
        request = urllib.request.urlopen(BASE_URL + url)

    soup = bs4.BeautifulSoup(request.read())
    cur_item = soup.select("li.listOpened")[-1]
    return cur_item.findAll("li")


def get_url(item):
    a = item.find("a")
    return a.get("href")


def get_title(item):
    a = item.find("a")
    return a.text.strip()


def get_ext(url):
    exts = ["pdf", "png", "jpg", "jpeg"]
    for ext in exts:
        if ext in url:
            return ext


def download(url, dest_dir, dest_file):
    if not os.path.exists(dest_dir):
        os.mkdir(dest_dir)

    dest = dest_dir + "/" + dest_file
    if os.path.exists(dest):
        print("[INFO] Ignoring", dest)
    else:
        print("[DL]", dest)
        subprocess.check_output(["curl", "--retry", "3",
                                 "--silent", "--output", dest, url])


def handle_list(contents, apt):
    for item in contents:
        url = get_url(item)
        title = get_title(item)

        if "class" in item.attrs and "listClosed" in item.attrs["class"]:
            handle_list(expand(url), apt)

        elif "blob" in url:
            dest_name = title.replace('/', "_") + '.' + get_ext(url)
            download(BASE_URL + url, apt,  dest_name)

        else:
            print("[ERROR] Can't handle", item)

        time.sleep(1)


def is_ignored(airport):
    ignored_list = []
    for item in ignored_list:
        if item in airport.text:
            return True


def main():
    print("[INFO] Start up")
    APT_LIST_URL = "/csee/Satellite/navegacion-aerea/es"
    APT_LIST_URL += "/Page/1078418725163/?other=1083158950596"
    airports = expand(APT_LIST_URL)
    print("[INFO] Found", len(airports), "airports.")

    for airport in airports:
        if is_ignored(airport):
            continue

        # Prepare airport info
        apt_full = get_title(airport).split("- ")
        apt_name = apt_full[0].strip().title()
        apt_code = apt_full[1].strip()
        apt = "{} ({})".format(apt_code, apt_name)
        apt = apt.replace("/", "-")

        url = get_url(airport)
        handle_list(expand(url), apt)


if __name__ == '__main__':
    main()
