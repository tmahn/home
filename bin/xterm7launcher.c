/* xterm7launcher -- xterm launcher for cygwin on Windows 7 RC
 *
 * Launching xterms on the Windows 7 release candidate spawns multiple
 * blank consoles that linger on the screen. Closing them kills the xterm.
 * Apparently some console code was rewritten in Windows 7, and the
 * consoles that get allocated by the cygwin kernel on system calls like
 * exec() are now drawn on the screen instead of the “fake window station”
 * that cygwin created as a workaround for previous versions of windows.
 *
 * See for example the mail threads:
 *   http://www.cygwin.com/ml/cygwin/2009-03/msg01029.html
 *   http://www.cygwin.com/ml/cygwin/2009-04/msg00151.html
 *   http://www.cygwin.com/ml/cygwin/2009-05/msg00224.html
 *   http://www.cygwin.com/ml/cygwin-xfree/2009-05/msg00027.html
 *
 * This program allocates a console and immediately hides it. This *will*
 * flicker, but only briefly, and the console will not appear in the
 * taskbar once the flickering is over.
 *
 * Additionally, you won’t even see the flicker if you launch xterm via a
 * shortcut that is set to run minimized; the console will be minimized for
 * the fraction of a second it is visible, and the xterm will display
 * normally. Since you’ll probably launch xterm via a shortcut in the start
 * menu, you probably won’t see a console at all.
 */

#define _WIN32_WINNT 0x0600
#include <windows.h>
#include <winsock2.h>
#include <ws2tcpip.h>
#include <errno.h>
#include <process.h>
#include <stdio.h>

#define ARRAY_SIZE(arr) (sizeof(arr)/sizeof(arr[0]))

#define BUFFER_SIZE 1024

const char* xterm_path = "c:\\cygwin\\bin\\xterm.exe";

char *env[] =
{
    NULL,
    "PATH=c:\\cygwin\\bin",
    NULL
};

char hostname[BUFFER_SIZE];

/* Ignore the error message, and exit with a non-zero return code. */
void report_error(const char* error_message) {
    exit(1); 
}

/* Return this host’s fully-qualified domain name. The string is kept in
 * the global static buffer “hostname”. */
char* getFQDN() {
    WSADATA wsadata;
    WSAStartup(MAKEWORD(2, 2), &wsadata);

    if (gethostname(hostname, ARRAY_SIZE(hostname)))
        report_error("gethostname() failed");
    struct hostent* hostent = gethostbyname(hostname);
    if (hostent == NULL)
        report_error("gethostbyname() failed");
    strncpy(hostname, hostent->h_name, ARRAY_SIZE(hostname));
    hostname[ARRAY_SIZE(hostname) - 1] = 0;

    WSACleanup();
    return hostname;
}

/* Start an xterm, allocating and hiding the console. */
int main() {
    char display_buffer[BUFFER_SIZE];
    snprintf(display_buffer, ARRAY_SIZE(display_buffer),
        "DISPLAY=%s:0.0", getFQDN());
    env[0] = display_buffer;

    AllocConsole();
    ShowWindow(GetConsoleWindow(), SW_HIDE);
    if (_execle(xterm_path, "xterm", NULL, env) == -1)
    {
        report_error("xterm exec failed");
    }

    return 0;
}
