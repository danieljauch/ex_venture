defmodule Web.Admin.RaceSkillController do
  use Web.AdminController

  alias Web.Race
  alias Web.Skill

  def new(conn, %{"race_id" => race_id}) do
    race = Race.get(race_id)
    changeset = Race.new_race_skill(race)
    skills = Skill.all()

    conn
    |> assign(:race, race)
    |> assign(:skills, skills)
    |> assign(:changeset, changeset)
    |> render("new.html")
  end

  def create(conn, %{"race_id" => race_id, "race_skill" => %{"skill_id" => skill_id}}) do
    race = Race.get(race_id)

    case Race.add_skill(race, skill_id) do
      {:ok, _race_skill} ->
        conn
        |> put_flash(:info, "Skill added!")
        |> redirect(to: race_path(conn, :show, race.id))

      {:error, changeset} ->
        skills = Skill.all()

        conn
        |> put_flash(:error, "Could not add skill. Please pick another.")
        |> assign(:race, race)
        |> assign(:skills, skills)
        |> assign(:changeset, changeset)
        |> render("new.html")
    end
  end

  def delete(conn, %{"id" => id}) do
    case Race.remove_skill(id) do
      {:ok, race_skill} ->
        conn
        |> put_flash(:info, "Skill removed!")
        |> redirect(to: race_path(conn, :show, race_skill.race_id))

      _ ->
        conn
        |> put_flash(:error, "Could not remove the skill. Please try again.")
        |> redirect(to: dashboard_path(conn, :index))
    end
  end
end
