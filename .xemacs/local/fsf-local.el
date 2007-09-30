; Things to make libraries that were written for FSF emacs work

(defun tty-color-off-gray-diag (r g b)
  "Compute the angle between the color given by R,G,B and the gray diagonal.
The gray diagonal is the diagonal of the 3D cube in RGB space which
connects the points corresponding to the black and white colors.  All the
colors whose RGB coordinates belong to this diagonal are various shades
of gray, thus the name."
  (let ((mag (sqrt (* 3 (+ (* r r) (* g g) (* b b))))))
    (if (< mag 1) 0 (acos (/ (+ r g b) mag)))))

(provide 'fsf-local)
