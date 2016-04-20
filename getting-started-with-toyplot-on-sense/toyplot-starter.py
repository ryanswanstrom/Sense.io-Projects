# Upgrade pip and install toyplot
!pip install --upgrade pip
!pip install toyplot

# Setup
# -----

import sense
import numpy
import toyplot
import toyplot.browser
toyplot.browser.show(canvas)

x = numpy.linspace(0, 10)
y = x ** 2

canvas = toyplot.Canvas(width=300, height=300)
axes = canvas.axes()
mark = axes.plot(x, y)
toyplot.browser.show(canvas)
