function! KeyLO(modes, current_layout, ...)
	" map/noremap
	if a:0 > 1 
		if a:2 ==# 'map'
			let l:map = 1
			echom 'KeyLO: Using "map" rather than "noremap", be careful!'
		else
			echom 'KeyLO: map argument "'.a:2.'" not valid, should be "map" or empty'
			return
		endif
	else
		let l:map = 0
	endif

	" MODES
	if a:modes =~ '[^acilnosvx ]'
		echom 'KeyLO: invalid modes argument, can only contain characters [acilnosvx<space>]'
		return
	endif

	let l:modes = a:modes

	if l:modes =~ 'a'
		let l:modes = 'nvoilc'
	endif


	" LAYOUTS
	let l:presets = {
		\'qwerty_uk'	: "-_=+qQwWeErRtTyYuUiIoOpP[{]}aAsSdDfFgGhHjJkKlL;:'@zZvVcCvVbBnNmM,<.>/?",
		\'qwerty_us'	: "-_=+qQwWeErRtTyYuUiIoOpP[{]}aAsSdDfFgGhHjJkKlL;:'\"zZxXcCvVbBnNmM,<.>/?",
		\'colemak_uk'	: "-_=+qQwWfFpPgGjJlLuUyY;:[{]}aArRsStTdDhHnNeEiIoO'@zZxXcCvVbBkKmM,<.>/?",
		\'colemak_us'	: "-_=+qQwWfFpPgGjJlLuUyY;:[{]{aArRsStTdDhHnNeEiIoO'\"zZvVcCvVbBkKmM,<.>/?",
		\'dvorak'		: "[{]}'\",<.>pPyYfFgGcCrRlL/?=+aAoOeEuUiIdDhHtTnNsS-_;:qQjJkKxXbBmMwWvVzZ",
		\'tarmak1_uk'	: "-_=+qQwWjJrRtTyYuUiIoOpP[{]}aAsSdDfFgGhHnNeElL;:'@zZxXcCvVbBkKmM,<.>/?",
		\'tarmak1_us'	: "-_=+qQwWjJrRtTyYuUiIoOpP[{]}aAsSdDfFgGhHnNeElL;:'\"zZxXcCvVbBkKmM,<.>/?",
		\'tarmak2_uk'	: "-_=+qQwWfFrRgGyYuUiIoOpP[{]}aAsSdDtTjJhHnNeElL;:'@zZxXcCvVbBkKmM,<.>/?",
		\'tarmak2_us'	: "-_=+qQwWfFrRgGyYuUiIoOpP[{]}aAsSdDtTjJhHnNeElL;:'\"zZxXcCvVbBkKmM,<.>/?",
		\'tarmak3_uk'	: "-_=+qQwWfFjJgGyYuUiIoOpP[{]}aArRsStTdDhHnNeElL;:'@zZxXcCvVbBkKmM,<.>/?",
		\'tarmak3_us'	: "-_=+qQwWfFjJgGyYuUiIoOpP[{]}aArRsStTdDhHnNeElL;:'\"zZxXcCvVbBkKmM,<.>/?",
		\'tarmak4_uk'	: "-_=+qQwWfFpPgGjJuUiIyY;:[{]}aArRsStTdDhHnNeElLoO'@zZxXcCvVbBkKmM,<.>/?",
		\'tarmak4_us'	: "-_=+qQwWfFpPgGjJuUiIyY;:[{]}aArRsStTdDhHnNeElLoO'\"zZxXcCvVbBkKmM,<.>/?",
		\'numbers'		: '1234567890',
		\'symbols_uk'	: '!"£$%^&*()',
		\'symbols_us'	: '!@#$%^&*()',
		\}

	let l:current_layout = a:current_layout
	for l:key in keys(l:presets)
		if l:current_layout ==? l:key
			let l:current_layout = l:presets[l:key]
		endif
	endfor
	let l:current_layout_keys = split(l:current_layout, '\zs')

	" If a 3rd arg given, prepare to use as new layout to swap current one for.
	" Otherwise, prepare to unset any mappings from the current layout
	if a:0 > 0
		let l:new_layout = a:1
		for l:key in keys(l:presets)
			if l:new_layout ==? l:key
				let l:new_layout = l:presets[l:key]
			endif
		endfor
		let l:new_layout_keys = split(l:new_layout, '\zs')

		" layout lengths must match for even swap
		let l:c = len(l:current_layout_keys)
		let l:n = len(l:new_layout_keys)
		if l:c != l:n
			echom 'Keylo: layouts of different length - current: '.l:c.', new: '.l:n
			echom l:current_layout
			echom l:new_layout
			return
		endif

		let l:remap = 1

	else
		let l:remap = 0
	endif

	" TODO: avoid/translate captured commands e.g. yy
	" REMAPPING
	for l:mode in split(l:modes, '\zs')
		echom l:mode

		let l:i = 0
		while l:i < len(l:current_layout_keys)
			if l:map ==# 1
				execute ':'.l:mode.'map '.l:current_layout_keys[l:i].' '.l:new_layout_keys[l:i]
			elseif l:remap ==# 1
				execute ':'.l:mode.'noremap '.l:current_layout_keys[l:i].' '.l:new_layout_keys[l:i]
			else
				execute ':'.l:mode.'unmap '.l:current_layout_keys[l:i]
			endif
			let l:i += 1
		endwhile
	endfor
endfunction
