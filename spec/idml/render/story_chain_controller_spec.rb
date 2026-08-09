# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::Render::StoryChainController do
  let(:controller) { described_class.new }

  let(:empty_state) do
    described_class::State.new(
      paragraphs: [], current_paragraph: nil,
      runs_remaining: [], char_cursor: 0
    )
  end

  let(:nonempty_state) do
    described_class::State.new(
      paragraphs: [
        Idml::Render::StyleResolver::Paragraph.new(runs: [], alignment: :left),
      ],
      current_paragraph: nil,
      runs_remaining: [],
      char_cursor: 42,
    )
  end

  describe "#state_for / #store_state" do
    it "returns nil for unknown story_id" do
      expect(controller.state_for("u1")).to be_nil
    end

    it "stores and retrieves state by story_id" do
      controller.store_state("u1", nonempty_state)
      expect(controller.state_for("u1")).to eq(nonempty_state)
    end

    it "removes the state when storing nil" do
      controller.store_state("u1", nonempty_state)
      controller.store_state("u1", nil)
      expect(controller.state_for("u1")).to be_nil
    end

    it "removes the state when storing an empty state" do
      controller.store_state("u1", nonempty_state)
      controller.store_state("u1", empty_state)
      expect(controller.state_for("u1")).to be_nil
    end
  end

  describe "#has_pending?" do
    it "returns false when no state stored" do
      expect(controller.has_pending?("u1")).to be false
    end

    it "returns true when state is stored" do
      controller.store_state("u1", nonempty_state)
      expect(controller.has_pending?("u1")).to be true
    end

    it "returns false after state is cleared" do
      controller.store_state("u1", nonempty_state)
      controller.store_state("u1", empty_state)
      expect(controller.has_pending?("u1")).to be false
    end
  end
end
