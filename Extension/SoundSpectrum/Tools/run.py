import sys

from pylab import*
from scipy.io import wavfile
from PIL import Image, ImageDraw

FPS = 30

TEXTURE_WIDTH = 256
TEXTURE_HEIGHT = 256

FFT_SAMPLE_WAVE_1 = 0.01
FFT_SAMPLE_WAVE_2 = 0.02
FFT_SAMPLE_WAVE_3 = 0.03
FFT_SAMPLE_WAVE_4 = 0.04
FFT_SAMPLE_WAVE_5 = 0.05
FFT_SAMPLE_WAVE_6 = 0.06
FFT_SAMPLE_WAVE_7 = 0.07
FFT_SAMPLE_WAVE_8 = 0.08

FFT_SCOPE = 1024
FFT_UNIFORM = 150

def FFT(s1):
	global fft_max
	n = len(s1) 
	p = fft(s1)
	nUniquePts = int(ceil((n+1)/2.0))
	p = p[0:nUniquePts]
	p = abs(p)
	p = p / float(n)
	p = p**2

	if n % 2 > 0:
		p[1:len(p)] = p[1:len(p)] * 2
	else:
		p[1:len(p) -1] = p[1:len(p) - 1] * 2

	ret = [abs(10*log10(x+1e-5)) for x in p]
	return ret

def gen(fn):
	sampFreq, snd = wavfile.read(fn)

	snd = snd / (2.0 ** 15)
	soundLength = len(snd) / sampFreq
	s1 = snd[:,0]

	print "INFO: Fps = ", FPS
	print "INFO: Sound length = ", int(soundLength * FPS)
	print "INFO: Left channel size =", len(s1)

	img1 = Image.new("RGBA", (TEXTURE_WIDTH,TEXTURE_HEIGHT), color=(0,0,0,0))
	img2 = Image.new("RGBA", (TEXTURE_WIDTH,TEXTURE_HEIGHT), color=(0,0,0,0))

	draw1 = ImageDraw.Draw(img1)
	draw2 = ImageDraw.Draw(img2)

	rangeStep = sampFreq / FPS
	rangeLimits = int(soundLength * FPS);

	limit = 0.0;

	for i in xrange(rangeLimits):
		start_index = rangeStep * i
		end_index = start_index + FFT_SCOPE

		if  end_index >= len(s1):
			end_index = len(s1) - 1

		if (start_index > 0.5 * rangeStep):
			start_index -= 0.5 * rangeStep
			end_index -= 0.5 * rangeStep

		fft_data = s1[int(start_index):int(end_index)]
		fft_ret = FFT(fft_data)
		fft_ret_len = len(fft_ret)

		limit = max(limit, fft_ret[int(FFT_SAMPLE_WAVE_8*fft_ret_len)])

	print "INFO: Max limit =", limit

	for i in xrange(rangeLimits):
		start_index = rangeStep * i
		end_index = start_index + FFT_SCOPE

		if  end_index >= len(s1):
			end_index = len(s1) - 1
			
		if (start_index > 0.5 * rangeStep):
			start_index -= 0.5 * rangeStep
			end_index -= 0.5 * rangeStep

		fft_data = s1[int(start_index):int(end_index)]
		fft_ret = FFT(fft_data)
		fft_ret_len = len(fft_ret)

		rgba1 = [fft_ret[int(FFT_SAMPLE_WAVE_1*fft_ret_len)],
				fft_ret[int(FFT_SAMPLE_WAVE_2*fft_ret_len)],
				fft_ret[int(FFT_SAMPLE_WAVE_3*fft_ret_len)],
				fft_ret[int(FFT_SAMPLE_WAVE_4*fft_ret_len)]]
				
		rgba2 = [fft_ret[int(FFT_SAMPLE_WAVE_5*fft_ret_len)],
				fft_ret[int(FFT_SAMPLE_WAVE_6*fft_ret_len)],
				fft_ret[int(FFT_SAMPLE_WAVE_7*fft_ret_len)],
				fft_ret[int(FFT_SAMPLE_WAVE_8*fft_ret_len)]]

		rgba1 = [255 * (1.0 - x / limit) for x in rgba1]
		rgba2 = [255 * (1.0 - x / limit) for x in rgba2]

		px = i % TEXTURE_WIDTH;
		py = i / TEXTURE_HEIGHT;

		draw1.point((px, py), fill=(int(rgba1[0]), int(rgba1[1]), int(rgba1[2]), int(rgba1[3])))
		draw2.point((px, py), fill=(int(rgba2[0]), int(rgba2[1]), int(rgba2[2]), int(rgba2[3])))

	img1.save(fn+"1.png", 'png')
	img2.save(fn+"2.png", 'png')

if __name__ == "__main__":
	if len(sys.argv) == 2:
		fn = sys.argv[1]
		gen(fn)
		print 'DONE...'
	else:
		print "ERROR! Please enter a path to a wav file..."

	raw_input()