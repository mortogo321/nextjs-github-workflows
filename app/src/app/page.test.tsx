import { describe, expect, it } from "vitest";
import { render, screen } from "@testing-library/react";
import Home from "@/app/page";

describe("Home page", () => {
  it("renders the Next.js logo", () => {
    render(<Home />);
    expect(screen.getByAltText("Next.js logo")).toBeDefined();
  });

  it("renders the docs link", () => {
    render(<Home />);
    expect(screen.getByText("Read our docs")).toBeDefined();
  });
});
