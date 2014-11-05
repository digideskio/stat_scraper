#!/usr/bin/ruby

require 'yaml'
require 'mechanize'
require 'csv'

# Scrapes Course Statistics from Canvas-LMS
class StatisticsScraper

  def initialize
    @config = YAML.load_file('config.yml')
    @agent = Mechanize.new
  end

  def host
    @config['host']
  end

  def authenticate
    # Go to login page
    login_page = @agent.get(host + "/login?canvas_login=1")

    # Submit the login form
    # pp login_page.form_with(:action => '/login?nonldap=true')
    my_page = login_page.form_with(:action => '/login?nonldap=true') do |f|
      f['pseudonym_session[unique_id]'] = @config['auth_user']
      f['pseudonym_session[password]'] = @config['auth_pass']
    end.click_button
  end

  def statistics(course_id)
    statistics_page = @agent.get(host + "/courses/#{course_id}/statistics")
    statistics_cells = statistics_page.search("div#tab-totals table td")

    # puts "cells count: #{statistics_cells.count}"
    # statistics_cells.each_with_index do |cell, i|
    #   puts "cell [#{i}]: #{cell.text}"
    # end

    statistics = {}
    statistics['discussions'] = statistics_cells[1].text.to_i
    statistics['discussions_entries'] = statistics_cells[3].text.to_i
    statistics['assignments'] = statistics_cells[9].text.to_i
    statistics['assignment_groups'] = statistics_cells[11].text.to_i
    statistics['course_rubrics'] = statistics_cells[13].text.to_i
    statistics['all_rubrics'] = statistics_cells[15].text.to_i
    statistics['active_students'] = statistics_cells[17].text.to_i
    statistics['unaccepted_students'] = statistics_cells[19].text.to_i
    statistics['quizes'] = statistics_cells[21].text.to_i
    statistics['quiz_questions'] = statistics_cells[23].text.to_i
    statistics['quiz_submissions'] = statistics_cells[25].text.to_i
    statistics
  end

  def report_course_ids
    course_ids = []
    CSV.foreach('reports/' + @config['report_filename'], :headers => :first_row) do |course|
      course_ids << course['canvas_course_id']
    end
    course_ids
  end

  def new_statistics_report_file
    headers = [
      'course_id',
      'discussions',
      'discussions_entries',
      'assignments',
      'assignment_groups',
      'course_rubrics',
      'all_rubrics',
      'active_students',
      'unaccepted_students',
      'quizes',
      'quiz_questions',
      'quiz_submissions'
    ]
    @statistics_report_file = CSV.open('reports/' + @config['statistics_filename'], 'wb', { :headers => headers, :write_headers => true})
  end

  def scrape
    authenticate
    report_file = new_statistics_report_file
    report_course_ids.each do |course_id|
      stats = statistics(course_id)
      stats['course_id'] = course_id
      puts "stats: #{stats}"
      report_file << stats
    end
    puts "---------------------------"
    puts "Report Generation Completed"
    puts "---------------------------"
  end
end

proxy = StatisticsScraper.new
proxy.scrape

