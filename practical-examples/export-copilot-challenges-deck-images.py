from pathlib import Path


deck = Path(__file__).with_name("microsoft-copilot-challenges-agent-comparison.pptx").resolve()
out_dir = Path(__file__).with_name("microsoft-copilot-challenges-agent-comparison-slides")
out_dir.mkdir(exist_ok=True)

try:
    import win32com.client
except Exception as exc:
    raise SystemExit(f"PowerPoint export unavailable: {exc}")

powerpoint = win32com.client.Dispatch("PowerPoint.Application")
presentation = powerpoint.Presentations.Open(str(deck), WithWindow=False)
try:
    for slide in presentation.Slides:
        slide.Export(str(out_dir / f"slide-{slide.SlideIndex:02d}.png"), "PNG", 1600, 900)
finally:
    presentation.Close()
    powerpoint.Quit()

print(out_dir)