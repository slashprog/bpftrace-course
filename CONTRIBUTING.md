# Contributing

Thanks for using (and possibly improving) the course materials! Here are the most useful ways to contribute:

## 🐛 Reporting issues

The most valuable contribution: tell us when a script doesn't work on your setup. When opening an issue, please include:

- Your OS and version (`lsb_release -a` or `cat /etc/os-release`)
- Your kernel version (`uname -r`)
- Your bpftrace version (`bpftrace --version`)
- The script you ran
- The full error output

## 🔧 Submitting a new one-liner or playbook

1. Fork the repo
2. Add your script to the appropriate `one-liners/` category or `section-06-playbooks/`
3. Use the file-naming convention: `domain-problem.bt` (e.g., `oom-by-process.bt`)
4. Include a header comment block:

```bpftrace
#!/usr/bin/env bpftrace
/*
 * Title:    <one-line description>
 * Author:   <your name or handle>
 * Tested:   Ubuntu 24.04, kernel 6.x, bpftrace 0.20
 * Usage:    sudo bpftrace <script>.bt
 * Notes:    <anything important — e.g., needs CAP_BPF, only works on certain kernels>
 */
```

5. Open a PR with a short description of what your script does and when you'd reach for it

## 📚 Improving documentation

Spotted a typo? A confusing section? An out-of-date command? PRs welcome.

## 🤝 Community guidelines

- Be kind. Everyone is debugging something for the first time.
- Be specific. "Doesn't work" → "<error> on <distro> with <version>"
- Don't share secrets. If your script traces proprietary paths or processes, anonymize.

## 📦 Pull request process

1. Run your script on a clean Ubuntu 24.04 + kernel 6.x setup to verify
2. Make sure `bpftrace <script>.bt -d` parses without errors
3. Update the relevant README.md if you add a new file
4. Squash your commits into a single clean change

Thanks again — every contribution makes the course better for the next student.
