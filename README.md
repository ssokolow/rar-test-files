# RAR Test Files

This repository contains a collection of minimal, legally redistributable `.rar`
and `.cbr` test files suitable for inclusion in test suites for program that
incorporate RAR extraction functionality.

## Explain

The only legal way to create a RAR file is with
[WinRAR](https://www.rarlab.com/), and far too many people have already run out
their 40-day trial period for WinRAR long ago, myself included.

I bought a WinRAR license to use on my Windows XP retro-hobby computer so I
could be authentic to my nostalgia without license violations or nag screens and
then used it to generate some
[RAR](<https://en.wikipedia.org/wiki/RAR_(file_format)>) and
[CBR](https://en.wikipedia.org/wiki/Comic_book_archive) files to serve as test
fixtures for the integration tests in a project I'm working on which invokes
`unrar` as a subprocess.

Since I had so much trouble finding test files I could feel confident in the
legality of, I decided to share mine for others to use.

**NOTE:** If you can provide simple instructions for how I can build some
[`.spc`](https://wiki.superfamicom.org/spc-and-rsn-file-format) files that are
legally in the clear, I'll add some `.rsn` files to this repository. My
understanding is that they embed music playback code from the ROM they were
ripped from.

## How can I be sure you have a WinRAR license?

These were made using the digital delivery copy of the license but I also paid
for the "WinRAR Physical Delivery on CD" option as extra proof of purchase. When
that arrives, I'll take a confirmation photo and add it to this repository.

Aside from that, cleverbridge (the fulfillment company involved) doesn't give me
much uniquely identifiable stuff I could share. I obviously can't share the key
and I don't know whether sharing my order reference number would open me up to
the risk of someone else impersonating me.

## Why are there so many different files?

The project I made them for is intended as a frontend for detecting corruption
in as wide a range of files as possible.

- I made both RAR3 and RAR5 archives because
  [p7zip](https://sourceforge.net/projects/p7zip/) 9.20 as
  [distributed](https://packages.ubuntu.com/xenial/p7zip) by Ubuntu Linux 16.04
  LTS supports the former but not the latter, so I need to test that my tooling
  doesn't get tripped up by assuming that `7z t` is just as good a choice as
  `unrar t`.
- I made both `.rar` and `.cbr` files because, in the future, I plan for my tool
  to do more well-formedness checking for "archive with a standard internal
  structure" formats than just asking `unrar` to check the hashes.
- I made authenticity verification, locked, recovery record, and solid variants
  because my planned testing harness will do things like walking bit-flips
  through the file and I want to see how those various features might affect
  what percentage of the bits will successfully trigger verification failure if
  flipped.
- I made self-extractors because I'm going to need all the help I can get in
  making sure I properly test the filetype handler dispatch for things like
  `.exe` and `.bin` which don't map to a single handler. (eg. A `.exe` could
  need to be handled by `unrar`, `7z`,
  [`innoextract`](https://constexpr.org/innoextract/), various other
  unpackers... or just plain checked to ensure that the
  [PE](https://en.wikipedia.org/wiki/Portable_Executable),
  [NE](https://en.wikipedia.org/wiki/New_Executable),
  [LE/LX](http://fileformats.archiveteam.org/wiki/Linear_Executable), or
  [MZ](https://en.wikipedia.org/wiki/DOS_MZ_executable)-format executable
  appears to be structurally valid.)

## How were these files made?

As I bought a non-business WinRAR license, this is a hobby project, developed
under my own name, on a home computer, and the
[WinRAR EULA](https://www.win-rar.com/winrarlicense.html) contains this
clause...

> Home users may use their single computer usage license on all computers and
> mobile devices (USB drive, external hard drive, etc.) which are property of
> the license owner.

...I generated the files as follows:

1. **Common Setup:**

   1. A couple of years ago, I constructed a standard "contents of a tiny
      archive" test file named `testfile.txt` containing `Testing 123.\n`. This
      should be the only contents of the `.rar` and `.exe` archives.
   1. A couple of years ago, I used [GIMP](https://www.gimp.org/) 2.8.16 (from
      the [Kubuntu Linux](https://kubuntu.org/getkubuntu/) 16.04 LTS (amd64)
      package repository) to craft standard `testfile.png` and `testfile.jpg`
      files consisting of a 2px by 2px checkerboard and then recompressed them
      using [`pngcrush`](https://pmt.sourceforge.io/pngcrush/),
      [`optipng`](http://optipng.sourceforge.net/),
      [AdvanceCOMP](https://en.wikipedia.org/wiki/AdvanceCOMP), and
      [`jpegoptim`](https://github.com/tjko/jpegoptim) to maximize the
      efficiency of certain kinds of synthesized corruption testing. These
      should be the only contents of the `.cbr` files.

1. **RAR5 Files Except Windows Self-Extractors:**

   1. Install RAR 5.30 beta 2 on my Linux PC using the
      [`rar`](https://packages.ubuntu.com/xenial/rar) package in the Ubuntu
      Linux 16.04 LTS (amd64) package repositories.
   1. Copy `rarreg.key` to `~/.rarreg.key` to register the installation.
   1. Run the following commands in the terminal:

      ```sh
      rar a -m5 -ma5 -t testfile.rar5.rar testfile.txt
      rar a -m5 -ma5 -t testfile.rar5.cbr testfile.{jpg,png}
      rar a -m5 -ma5 -t -k testfile.rar5.locked.rar testfile.txt
      rar a -m5 -ma5 -t -k testfile.rar5.locked.cbr testfile.{jpg,png}
      rar a -m5 -ma5 -t -rr testfile.rar5.rr.rar testfile.txt
      rar a -m5 -ma5 -t -rr testfile.rar5.rr.cbr testfile.{jpg,png}
      rar a -m5 -ma5 -t -s testfile.rar5.solid.rar testfile.txt
      rar a -m5 -ma5 -t -s testfile.rar5.solid.cbr testfile.{jpg,png}
      rar a -m5 -ma5 -t -sfx testfile.rar5.linux_sfx.bin testfile.txt
      ```

1. **RAR3 Files Except Windows Self-Extractors:**

   1. Download [RAR 3.93 for DOS](http://www.rarlab.com/rar/rarx393.exe) from
      rarlab.com and upload it to [VirusTotal](https://virustotal.com/) to
      double-check that it's clean.

   1. Install [DOSBox](https://www.dosbox.com/) (`0.74-4.2+deb9u2build0.16.04.1`
      from the `dosbox` package in the aforementioned package repository) on my
      Linux PC.
   1. Run the RAR 3.93 installer inside DOSBox and then copy `rarreg.key` into
      `C:\RAR` (assuming you ran `rarx393.exe` in the root of the virtual drive)
   1. Copy the test data into `C:\RAR`
   1. Run the same commands as in the RAR5 version, but with the following
      changes:

      1. Use `rar32` instead of `rar` for the command name
      1. Omit the `-ma5` flag
      1. Use `testfile.rar` as the output filename to deal with MS-DOS 8.3
         restrictions.
      1. Manually write `testfile.jpg testfile.png` instead of using
         `{jpg,png}`.
      1. Include a variant with `-av` for the authenticity verification feature
         removed in modern RAR versions.

      ...alternating with these commands in a terminal outside DOSBox to produce
      the final filenames:

      ```sh
      mv -i ~/.dosbox/RAR/TESTFILE.RAR testfile.rar3.rar
      mv -i ~/.dosbox/RAR/TESTFILE.RAR testfile.rar3.av.rar
      mv -i ~/.dosbox/RAR/TESTFILE.RAR testfile.rar3.locked.rar
      mv -i ~/.dosbox/RAR/TESTFILE.RAR testfile.rar3.rr.rar
      mv -i ~/.dosbox/RAR/TESTFILE.RAR testfile.rar3.solid.rar
      mv -i ~/.dosbox/RAR/TESTFILE.EXE testfile.rar3.dos_sfx.exe
      mv -i ~/.dosbox/RAR/TESTFILE.RAR testfile.rar3.cbr
      mv -i ~/.dosbox/RAR/TESTFILE.RAR testfile.rar3.av.cbr
      mv -i ~/.dosbox/RAR/TESTFILE.RAR testfile.rar3.locked.cbr
      mv -i ~/.dosbox/RAR/TESTFILE.RAR testfile.rar3.rr.cbr
      mv -i ~/.dosbox/RAR/TESTFILE.RAR testfile.rar3.solid.cbr
      ```

1. **RAR5 Windows Self-Extractors:**

   1. Download the
      [WinRAR x86 (32 bit) 6.01 beta 1](https://www.rarlab.com/rar/wrar601b1.exe)
      installer from rarlab.com and upload it to
      [VirusTotal](https://virustotal.com/) to double-check that it's clean.
   1. Copy the installer and the original `rarkey.rar` file I received,
      containing `rarreg.key`, to a USB flash drive.
   1. Power on my Windows XP retro-hobby PC (a Lenovo 3000 J Series that's still
      running its original factory Windows XP Professional install and is kept
      disconnected from the Internet) and plug in the USB flash drive.
   1. Install and register WinRAR 6.01 beta 1.
   1. Generate `testfile.rar5.wingui.sfx.exe` and
      `testfile.rar5.wincon.sfx.exe`.
   1. Move those files to the USB flash drive.
   1. Plug the flash drive back into my Linux PC.
   1. Commit the self-extractors to the local copy of the repository _before_
      checking them on VirusTotal to make it significantly more involved for
      modifications to sneak in _after_ the virus scan.
   1. Upload the resulting self-extractors to VirusTotal to make sure there are
      no viruses lurking somewhere in my setup that infected the self-extractor
      stubs.

1. **RAR3 Windows Self-Extractors:**

   1. Download [WinRAR 3.93](http://www.rarlab.com/rar/wrar393.exe) from
      rarlab.com and upload it to [VirusTotal](https://virustotal.com/) to
      verify that it's clean.
   1. Copy the installer and the original `rarkey.rar` file I received,
      containing `rarreg.key`, to a USB flash drive.
   1. Power on my Windows XP retro-hobby PC and start up
      [FreeSSHd](http://www.freesshd.com/).
   1. Power on my Windows 98 retro-hobby PC (a 133MHz AST Adventure! 210 with no
      USB ports that I upgraded to Windows 98 SE using my childhood retail-boxed
      copy of Windows 98 SE Upgrade).
   1. Use
      [WinSCP 4.4.0](https://sourceforge.net/projects/winscp/files/WinSCP/4.4/)
      on the Windows 98 side to copy across WinRAR 3.93 and `rarkey.rar` using
      the airgapped LAN I set up between my retro-hobby PCs.
   1. Install and register WinRAR 3.93.
   1. Generate `testfile.rar3.wingui.sfx.exe` and
      `testfile.rar3.wincon.sfx.exe`.
   1. Use WinSCP to move the RAR3 files back to the Windows XP machine.
   1. Move the RAR3 files onto the USB flash drive.
   1. Plug the flash drive back into my Linux PC.

1. **Post-Generation Tests:**
   1. Commit everything to the local copy of the repository _before_ running any
      checks so there is no unprotected window between checking for corruption
      or virus infection and generating the hashes.
   1. Run
      `for X in *.rar *.cbr *.exe *.bin; do unrar t -inul "$X" || echo "ERROR: $X"; done`
      to check for corruption.
   1. Upload all the self-extractors to [VirusTotal](https://virustotal.com/) to
      make sure there are no viruses lurking somewhere in my setup that infected
      the self-extractor stubs.

Had I been doing this under the aegis of a business, I'd have done the same
thing but with a few extra "uninstall RAR/WinRAR from machine X before
installing on machine Y" lines to be sure I'm satisfying the letter of the
business license terms.

## My virus scanner reports malware in these files

Check them on [VirusTotal](https://virustotal.com/). I'd be _very_ surprised if
it wasn't a false positive.

As of the time these files were created, the following files reported heuristic
detection false positives:

- `testfile.rar3.wincon.sfx.exe` is
  [reported](https://www.virustotal.com/gui/file/25c5e192a0575075b683bb4a185627771a8442fb550de9a606f388086f6872b6/detection)
  as "Malicious" by 1 scanner and as a heuristically-detected trojan by one
  other out of 67 scanners VirusTotal submitted it to.
- `testfile.rar3.wingui.sfx.exe` is
  [reported](https://www.virustotal.com/gui/file/79c7bfd43b75ecd1d582f2d0c0031334b72a5c41e1a1e45f2deeb16aeaac6dd2/detection)
  as "Malicious" by 1 out of the 67 scanners VirusTotal submitted it to.
- `testfile.rar5.wingui.sfx.exe` is
  [reported](https://www.virustotal.com/gui/file/9fd0df3589c699c6ca4a0a5f79cd54a337c38da80278972ce4b1c119eaaba25b/detection)
  as malicious by 6 of the 67 scanners VirusTotal submitted it to, with four of
  them listing virus/malware IDs that explicitly make it clear it was a
  heuristic match and the other two just saying "Malicious".

To be sure, I redid the `testfile.rar5.wingui.sfx.exe` build by verifying the
WinRAR x86 (32 bit) 6.01 beta 1 installer was clean, installing it into a fresh
Wine prefix (`wine-1.7.55` from the Ubuntu 16.04 LTS (amd64) repositories), and
got identical false positives from VirusTotal.

This pattern of less than 10% of VirusTotal's backends triggering and doing it
based on heuristic detection is a common form of false positive... especially
for self-extractors because heuristics tend to see compressed stuff inside an
EXE as suspicious. I've also observed it for things which are provably safe,
like an official install package for building
[NSIS](http://nsis.sourceforge.net/) installers... and NSIS is used by companies
like Amazon, Dropbox, Google, Ubisoft, and McAfee.

Also bear in mind that some of the scanners on VirusTotal will report failure
for reasons completely unrelated to malicious code. For example, installers for
versions of WinRAR prior to 5.7 will trigger a few scanners, not because they're
infected, but because they support extraction of `.ace` files and the DLL which
implements ACE extraction was found to contain a very serious exploitable
vulnerability.

## Future Plans

- Test files for
  [multi-volume RAR archives](https://documentation.help/WinRAR/HELPArcVolumes.htm)
  with and without `-vn`

## License

By design, the files within the archives have been created from scratch and are
minimally novel in the hope that they will be ineligible for copyright.

While I don't hold copyright to the self-extractor stubs present in the `.exe`
and `.bin` self-extracting test archives, they may be redistributed freely.

I hereby release anything in these archives that I _do_ hold copyright to into
the public domain using the Creative Commons
[CC0](http://creativecommons.org/publicdomain/zero/1.0/) public domain
dedication.

<p xmlns:dct="http://purl.org/dc/terms/" xmlns:vcard="http://www.w3.org/2001/vcard-rdf/3.0#">
  <a rel="license"
     href="http://creativecommons.org/publicdomain/zero/1.0/">
    <img src="http://i.creativecommons.org/p/zero/1.0/88x31.png" style="border-style: none;" alt="CC0" />
  </a>
  <br />
  To the extent possible under law,
  <span resource="[_:publisher]" rel="dct:publisher">
    <span property="dct:title">Stephan Sokolow</span></span>
  has waived all copyright and related or neighboring rights to
  <span property="dct:title">RAR Test Files</span>.
This work is published from:
<span property="vcard:Country" datatype="dct:ISO3166"
      content="CA" about="[_:publisher]">
  Canada</span>.
</p>
