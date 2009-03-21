/* xdummyclient
 *
 * A dummy client which connects to an X display and handles events, and
 * nothing else.
 */

#include <err.h>
#include <stdio.h>
#include <unistd.h>
#include <X11/Xlib.h>

int main() {
    Display* dpy;
    dpy = XOpenDisplay(NULL);
    if (!dpy) {
	errx(1, "unable to open display '%s'\n", XDisplayName(NULL));
    }

    /* Receive events instead of just sleeping so that, if the display
     * terminates, we terminate. */
    while (1) {
        XEvent event;
        XNextEvent(dpy, &event);
    }
    return 0;
}
